;;; stops.el --- Better guards in Emacs Lisp -*- lexical-binding: t; -*-

;; Copyright (C) 2023-2026 James P. Howard, II
;; SPDX-License-Identifier: MIT

;; Author: James P. Howard, II <jh@jameshoward.us>
;; Maintainer: James P. Howard, II <jh@jameshoward.us>
;; Version: 1.0.0
;; Package-Requires: ((emacs "24.3"))
;; Keywords: lisp, tools
;; URL: https://github.com/k3jph/stops-el

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Stops provides two small guard macros for Emacs Lisp:
;;
;;   `stops-if!' signals an error when a condition is non-nil.
;;   `stops-if-not!' signals an error when a condition is nil.
;;
;; Both macros return t when the guard passes.  Both accept
;; `:error-type' and `:error-message' keyword arguments.

;;; Code:

(require 'cl-lib)

(defun stops--message (default-message error-message)
  "Return ERROR-MESSAGE, or DEFAULT-MESSAGE when ERROR-MESSAGE is nil."
  (or error-message default-message))

(defun stops--signal (error-type message)
  "Signal ERROR-TYPE with MESSAGE.

ERROR-TYPE defaults to `error'.  MESSAGE is passed as the single
error datum, following the usual `signal' convention that error
data are carried in a list."
  (signal (or error-type 'error) (list message)))

;;;###autoload
(cl-defmacro stops-if! (condition &key error-type error-message)
  "Signal an error if CONDITION is non-nil.

When CONDITION is nil, return t.  ERROR-TYPE defaults to `error'.
ERROR-MESSAGE, when non-nil, is used as the error message.  When
ERROR-MESSAGE is nil, the message names the failed guard condition."
  `(if ,condition
       (stops--signal
        ,error-type
        (stops--message
         ,(format "stops-if!: condition was non-nil: %S" condition)
         ,error-message))
     t))

;;;###autoload
(cl-defmacro stops-if-not! (condition &key error-type error-message)
  "Signal an error if CONDITION is nil.

When CONDITION is non-nil, return t.  ERROR-TYPE defaults to
`error'.  ERROR-MESSAGE, when non-nil, is used as the error
message.  When ERROR-MESSAGE is nil, the message names the failed
guard condition."
  `(if ,condition
       t
     (stops--signal
      ,error-type
      (stops--message
       ,(format "stops-if-not!: condition was nil: %S" condition)
       ,error-message))))

(provide 'stops)

;;; stops.el ends here
