;;; stops.el --- stops: Better Guards in Emacs Lisp -*- mode: emacs-lisp; -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2023 James P. Howard, II
;;
;; Author: "James P. Howard, II" <jh@jameshoward.us>
;; Maintainer: "James P. Howard, II" <jh@jameshoward.us>
;; Keywords: tools
;; Homepage: https://github.com/k3jph/guards-el
;; Package-Requires: ((emacs "24.3"))
;; Package-Version: 0.3.0
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  This package provides a suite of macros for Swift-like
;;  guards in Emacs Lisp.
;;
;;; Code:

;; Generic ensure for custom validations.
(cl-defmacro stops-if! (condition &optional &key (error-type) (error-message))
  "Raise an error if CONDITION is true.
Signal with the error type defined in ERROR-TYPE (default is \=error).
The error message will be ERROR-MESSAGE."
  `(if ,condition
       (signal (or ,error-type 'error)
               (if (stringp ,error-message)
                   ,error-message
                 (eval ,error-message)))
     't))

(cl-defmacro stops-if-not! (condition &optional &key (error-type) (error-message))
  "Raise an error if CONDITION is false.
Signal with the error type defined in ERROR-TYPE (default is \=error).
The error message will be ERROR-MESSAGE."
  `(if ,condition
       't
     (signal (or ,error-type 'error)
             (if (stringp ,error-message)
                 ,error-message
               (eval ,error-message)))))

(provide 'stops)

;;; stops.el ends here
