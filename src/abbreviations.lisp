;;;; See setup-terms.tex
(in-package :cl-ansi-spec)

(defparameter *abbreviations* (list))

(defun define-abbrev (name expansion)
  (push (cons name expansion) *abbreviations*))

(defun replace-all (string part replacement)
  "replace-all from the CL cookbook, with modifications."
  (with-output-to-string (out)
    (loop with part-length = (length part)
          for old-pos = 0 then (+ pos part-length)
          for pos = (search part string
                            :start2 old-pos
                            :test #'char=)
          do (write-string string out
                           :start old-pos
                           :end (or pos (length string)))
          when pos do (write-string replacement out)
          while pos)))

(defun expand-abbreviations (string)
  (let ((final-string string))
    (loop for (name . expansion) in *abbreviations* do
      (setf final-string
            (cl-ppcre:regex-replace-all (format nil "\\~A" name)
                                        final-string
                                        expansion)))
    final-string))

;;; Books

(define-abbrev "CLtL"
  "\\it{Common Lisp: The Language}")
(define-abbrev "CLtLTwo"
  "\\it{Common Lisp: The Language, Second Edition}")
(define-abbrev "RandomHouseDictionary"
  "\\it{The Random House Dictionary of the English Language, Second Edition, Unabridged}")
(define-abbrev "WebstersDictionary"
  "\\it{Webster's Third New International Dictionary the English Language, Unabridged}")
(define-abbrev "CondSysPaper"
  "\\it{Exceptional Situations in Lisp}")
(define-abbrev "GabrielBenchmarks"
  "\\it{Performance and Evaluation of Lisp Programs}")
(define-abbrev "KnuthVolThree"
  "\\it{The Art of Computer Programming, Volume 3}")
(define-abbrev "MetaObjectProtocol"
  "\\it{The Art of the Metaobject Protocol}")
(define-abbrev "AnatomyOfLisp"
  "\\it{The Anatomy of Lisp}")
(define-abbrev "FlavorsPaper"
  "\\it{Flavors: A Non-Hierarchical Approach to Object-Oriented Programming}")
(define-abbrev "LispOnePointFive"
  "\\it{Lisp 1.5 Programmer's Manual}")
(define-abbrev "Moonual"
  "\\it{Maclisp Reference Manual, Revision 0}")
(define-abbrev "Pitmanual"
  "\\it{The Revised Maclisp Manual}")
(define-abbrev "InterlispManual"
  "\\it{Interlisp Reference Manual}")
(define-abbrev "Chinual"
  "\\it{Lisp Machine Manual}")
(define-abbrev "SmalltalkBook"
  "\\it{Smalltalk-80: The Language and its Implementation}")
(define-abbrev "XPPaper"
  "\\it{XP: A Common Lisp Pretty Printing System}")

;;; Standards

(define-abbrev "IEEEFloatingPoint"
  "\\it{IEEE Standard for Binary Floating-Point Arithmetic}")
(define-abbrev "IEEEScheme"
  "\\it{IEEE Standard for the Scheme Programming Language}")
(define-abbrev "ISOChars"
  "\\rm{ISO 6937/2}")

;;; Papers

(define-abbrev "PrincipalValues"
  "Principal Values and Branch Cuts in Complex APL")
(define-abbrev "RevisedCubedScheme"
  "Revised\\sup{3} Report on the Algorithmic Language Scheme")
(define-abbrev "StandardLispReport"
  "Standard LISP Report")
(define-abbrev "NILReport"
  "NIL---A Perspective")
(define-abbrev "SOneCLPaper"
  "S-1 Common Lisp Implementation")
(define-abbrev "CLOSPaper"
  "Common Lisp Object System Specification")

;;; Terms Languages, Operating Systems, etc.

(define-abbrev "clisp"
  "\\rm{Common Lisp}")
(define-abbrev "Lisp"
  "\\rm{Lisp}")
(define-abbrev "maclisp"
  "\\rm{MacLisp}")
(define-abbrev "apl"
  "\\rm{APL}")
(define-abbrev "lmlisp" ;; Lisp Machine Lisp
  "\\rm{ZetaLisp}")
(define-abbrev "scheme"
  "\\rm{Scheme}")
(define-abbrev "interlisp"
  "\\rm{InterLisp}")
(define-abbrev "slisp"
  "\\rm{Spice Lisp}")
(define-abbrev "newlisp"
  "\\rm{S-1 Common Lisp}")
(define-abbrev "sOnelisp"
  "\\rm{Nil}")
(define-abbrev "fortran"
  "\\rm{Fortran}")
(define-abbrev "stdlisp"
  "\\rm{Standard Lisp}")
(define-abbrev "psl"
  "\\rm{Portable Standard Lisp}")
(define-abbrev "Unix"
  "\\rm{Unix}")
(define-abbrev "algol"
  "\\tt{Algol}")
(define-abbrev "TopsTwenty"
  "\\tt{TOPS-20}")

;;; Important Names

;;; General Phrases

(define-abbrev "etc"
  "\\it{etc.}")
(define-abbrev "ie"
  "\\it{i.e.}, ")
(define-abbrev "eg"
  "\\it{e.g.}, ")

;;; Domain-specific Phrases

(define-abbrev "defmethod"
  "defmethod")
(define-abbrev "CLOS"
  "object system")
(define-abbrev "OS"
  "object system")
