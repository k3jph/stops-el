;;; guards.el --- Guards in Emacs Lisp -*- mode: emacs-lisp; -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2023 James P. Howard, II
;;
;; Author: "James P. Howard, II" <jh@jameshoward.us>
;; Maintainer: "James P. Howard, II" <jh@jameshoward.us>
;; Keywords: tools
;; Homepage: https://github.com/k3jph/guards-el
;; Package-Requires: ((emacs "24.3"))
;; Package-Version: 0.1.0
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  This package provides a suite of macros for Swift-like
;;  guards in Emacs Lisp.
;;
;;; Code:

;; Ensure a variable is of a specified type.
(defmacro guard-type! (var type &optional signal-type)
  "Ensure that VAR is of TYPE.
Raises a SIGNAL-TYPE or `error' if not provided,
when the condition is not met."
  `(if (,type ,var)
       't
     (signal (or ,signal-type 'error) ,var)))

;; Ensure a number falls within a certain range.
(defmacro guard-range! (var min max &optional signal-type)
  "Ensure that VAR falls within the range MIN and MAX.
Raises a SIGNAL-TYPE or `error' if not provided,
when the condition is not met."
  `(if (and (>= ,var ,min) (<= ,var ,max))
       't
     (signal (or ,signal-type 'error) (list ,var ,min ,max))))

;; Ensure a list has a specific size.
(defmacro guard-list-size! (var size &optional signal-type)
  "Ensure that VAR has a size of SIZE.
Raises a SIGNAL-TYPE or `error' if not provided,
when the condition is not met."
  `(if (= (length ,var) ,size)
       't
     (signal (or ,signal-type 'error) (list ,var ,size))))

;; Validate that a string matches a pattern.
(defmacro guard-string-match! (var pattern &optional signal-type)
  "Ensure that VAR matches the regex PATTERN.
Raises a SIGNAL-TYPE or `error' if not provided,
when the condition is not met."
  `(if (string-match-p ,pattern ,var)
       't
     (signal (or ,signal-type 'error) (list ,var ,pattern))))

;; Generic ensure for custom validations.
(defmacro guard! (condition &optional signal-type)
  "Ensure that CONDITION is true.
Raises a SIGNAL-TYPE or `error' if not provided,
when the condition is not met."
  `(if ,condition
       't
     (signal (or ,signal-type 'error) (list ',condition))))

(provide 'guards)

;;; guards.el ends here
