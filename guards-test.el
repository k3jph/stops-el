;;; guards-test.el --- Guards for Emacs Lisp tests -*- mode: emacs-lisp; -*- lexical-binding: t; -*-

(require 'ert)
(require 'guards)

(define-error 'custom-error-type "Custom error for testing")

;;; Test for guard-type!
(ert-deftest test-guard-type-normal-operation ()
  (should (guard-type! 42 integerp)))

(ert-deftest test-guard-type-failure ()
  (should-error (guard-type! 42.0 integerp)))

(ert-deftest test-guard-type-custom-signal ()
  (should-error (guard-type! 42.0 integerp 'custom-error-type)
                :type 'custom-error-type))

;;; Test for guard-range!
(ert-deftest test-guard-range-normal-operation ()
  (should (guard-range! 42 0 100)))

(ert-deftest test-guard-range-failure ()
  (should-error (guard-range! 200 0 100)))

(ert-deftest test-guard-range-custom-signal ()
  (should-error (guard-range! 200 0 100 'custom-error-type)
                :type 'custom-error-type))

;;; Test for guard-list-size!
(ert-deftest test-guard-list-size-normal-operation ()
  (should (guard-list-size! '(1 2 3) 3)))

(ert-deftest test-guard-list-size-failure ()
  (should-error (guard-list-size! '(1 2) 3)))

(ert-deftest test-guard-list-size-custom-signal ()
  (should-error (guard-list-size! '(1 2) 3 'custom-error-type)
                :type 'custom-error-type))

;;; Test for guard-string-match!
(ert-deftest test-guard-string-match-normal-operation ()
  (should (guard-string-match! "hello" "^h")))

(ert-deftest test-guard-string-match-failure ()
  (should-error (guard-string-match! "hello" "^z")))

(ert-deftest test-guard-string-match-custom-signal ()
  (should-error (guard-string-match! "hello" "^z" 'custom-error-type)
                :type 'custom-error-type))

;;; Test for guard!
(ert-deftest test-guard-normal-operation ()
  (should (guard! t)))

(ert-deftest test-guard-failure ()
  (should-error (guard! nil)))

(ert-deftest test-guard-custom-signal ()
  (should-error (guard! nil 'custom-error-type)
                :type 'custom-error-type))

;;; guards-test.el ends here
