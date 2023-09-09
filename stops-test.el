;;; stops-test.el --- stops: Guards for Emacs Lisp tests -*- mode: emacs-lisp; -*- lexical-binding: t; -*-

(require 'ert)
(require 'stops)

;; Tests for `stops-if!`

;; Test when condition is true with default error-type and message (should signal 'error with default message)
(ert-deftest test-stops-if-true-condition-default-error ()
  (should-error (stops-if! t) :type 'error))

;; Test when condition is true with custom error-type (should signal custom type)
(define-error 'custom-error "My error for testing")
(ert-deftest test-stops-if-true-condition-custom-error ()
  (should-error (stops-if! t :error-type 'custom-error) :type 'custom-error))

;; Test when condition is true with custom error message (should signal 'error with custom message)
(ert-deftest test-stops-if-true-condition-custom-message ()
  (should (equal (condition-case err
                     (stops-if! t :error-message "custom message")
                   (error (cdr err)))
                 "custom message")))

;; Test when condition is true with custom error-type and custom message (should signal custom type with custom message)
(ert-deftest test-stops-if-true-condition-custom-error-and-message ()
  (should (equal (condition-case err
                     (stops-if! t :error-type 'custom-error :error-message "custom message")
                   (custom-error (cdr err)))
                 "custom message")))

;; Test when condition is false (should return 't)
(ert-deftest test-stops-if-false-condition ()
  (should (equal (stops-if! nil) 't)))

;; Tests for `stops-if-not!`

;; Test when condition is false with default error-type and message (should signal 'error with default error)
(ert-deftest test-stops-if-not-false-condition-default-error ()
  (should-error (stops-if-not! nil) :type 'error))

;; Test when condition is false with custom error-type (should signal custom type)
(ert-deftest test-stops-if-not-false-condition-custom-error ()
  (should-error (stops-if-not! nil :error-type 'custom-error) :type 'custom-error))

;; Test when condition is false with custom error message (should signal 'error with custom message)
(ert-deftest test-stops-if-not-false-condition-custom-message ()
  (should (equal (condition-case err
                     (stops-if-not! nil :error-message "custom message")
                   (error (cdr err)))
                 "custom message")))

;; Test when condition is false with custom error-type and custom message (should signal custom type with custom message)
(ert-deftest test-stops-if-not-false-condition-custom-error-and-message ()
  (should (equal (condition-case err
                     (stops-if-not! nil :error-type 'custom-error :error-message "custom message")
                   (custom-error (cdr err)))
                 "custom message")))

;; Test when condition is true (should return 't)
(ert-deftest test-stops-if-not-true-condition ()
  (should (equal (stops-if-not! t) 't)))

;;; stops-test.el ends here
