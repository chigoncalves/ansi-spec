(in-package :cl-user)
(defpackage ansi-spec.traverse
  (:use :cl)
  (:export :traverse)
  (:documentation "Traverse a TeX document, ignoring some nodes, extracting info
  from others into an output XML file."))
(in-package :ansi-spec.traverse)

;;; Output stream

(defvar *stream*)

(defun output (string)
  "Write a string to the output stream."
  (write-string string *stream*))

(defun strip-text (text)
  "Remove some text nonsense from some text."
  (ppcre:regex-replace-all "/"
                           (ppcre:regex-replace-all "\\/" text "")
                           ""))

;;; Modes

(defclass mode ()
  ((name :reader mode-name
         :initarg :name
         :type string
         :documentation "The name that triggers the mode.")
   (arity :reader mode-arity
          :initarg :arity
          :initform 0
          :type integer
          :documentation "The number of blocks, or bodies, the mode consumes.")
   (callback :reader mode-callback
             :initarg :callback
             :type function
             :documentation "A function that is called on each node."))
  (:documentation "A parser mode."))

(defparameter *modes* (make-hash-table :test #'equal)
  "A map of node names to mode objects.")

(defparameter *mode-counter* (make-hash-table :test #'equal)
  "A map of node names to the number of nodes they have yet to consume.")

(defparameter *active-nodes* (list)
  "A list of node tags.")

(defun get-mode (tag-name)
  "Find a node by tag-name. Return NIL if none is found."
  (gethash tag-name *modes*))

(defun activate-mode (tag-name)
  "Activate a node."
  (push tag-name *active-nodes*)
  (setf (gethash tag-name *mode-counter*)
        (mode-arity (get-mode tag-name))))

(defun deactivate-current-mode ()
  "Turn off the current active node."
  (pop *active-nodes*))

(defun current-mode ()
  "Return the current active mode object, or NIL."
  (get-mode (first *active-nodes*)))

(defun lower-mode-arity ()
  "Lower the arity of the current node."
  (decf (gethash (mode-name (current-mode)) *mode-counter*)))

(defun mode-ended-p ()
  "Has the current mode consumed all the nodes it needs?"
  (= 0 (gethash (mode-name (current-mode)) *mode-counter*)))

(defmacro define-mode ((tag-name node &key (arity 1)) &body body)
  "Define a mode."
  `(setf (gethash ,tag-name *modes*)
         (make-instance 'mode
                        :name ,tag-name
                        :arity ,arity
                        :callback (lambda (,node)
                                    ,@body))))

(defun on-node (node)
  "Dispatch a node."
  ;; If it has a tag, see if there's a corresponding mode.
  (when (plump:element-p node)
    (let ((tag (plump:tag-name node)))
      (if (get-mode tag)
          ;; Activate the mode
          (activate-mode tag)
          ;; Warn the user
          (warn "Tag ~S has no corresponding mode" tag))))
  ;; Dispatch it to the current mode
  (let ((mode (current-mode)))
    (if mode
        ;; If we have an active mode, call its callback
        (progn
          (funcall (mode-callback mode) node)
          ;; Lower the mode's arity
          (lower-mode-arity)
          ;; If the mode has consumed all the nodes it needs, shut it down
          (when (mode-ended-p)
            (deactivate-current-mode)))
        ;; If we don't, and the node is a text node, write it to the output
        ;; stream
        (when (plump:text-node-p node)
          (output (plump:text node))))))

;;; Interface

(defun traverse (pathname)
  "Traverse the document in pathname."
  (format t "~&Traversing '~A.tex'" (pathname-name pathname))
  (ansi-spec.file:with-output-file (*stream*)
    (plump:traverse (plump-tex:parse
                     (ansi-spec.preprocess:preprocess
                      (uiop:read-file-string pathname)))
                    #'(lambda (node)
                        (on-node node)))))
