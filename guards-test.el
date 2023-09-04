;;; guards-test.el --- Guards for Emacs Lisp tests -*- mode: emacs-lisp; -*- lexical-binding: t; -*-

(require 'ert)
(require 'guards)

(define-error 'custom-error-type "Custom error for testing")

;;; Test for guards-type!
(ert-deftest test-guards-type-normal-operation ()
  (should (guards-type! 42 integerp)))

(ert-deftest test-guards-type-failure ()
  (should-error (guards-type! 42.0 integerp)))

(ert-deftest test-guards-type-custom-signal ()
  (should-error (guards-type! 42.0 integerp 'custom-error-type)
                :type 'custom-error-type))

;;; Test for guards-range!
(ert-deftest test-guards-range-normal-operation ()
  (should (guards-range! 42 0 100)))

(ert-deftest test-guards-range-failure ()
  (should-error (guards-range! 200 0 100)))

(ert-deftest test-guards-range-custom-signal ()
  (should-error (guards-range! 200 0 100 'custom-error-type)
                :type 'custom-error-type))

;;; Test for guards-list-size!
(ert-deftest test-guards-list-size-normal-operation ()
  (should (guards-list-size! '(1 2 3) 3)))

(ert-deftest test-guards-list-size-failure ()
  (should-error (guards-list-size! '(1 2) 3)))

(ert-deftest test-guards-list-size-custom-signal ()
  (should-error (guards-list-size! '(1 2) 3 'custom-error-type)
                :type 'custom-error-type))

;;; Test for guards-string-match!
(ert-deftest test-guards-string-match-normal-operation ()
  (should (guards-string-match! "hello" "^h")))

(ert-deftest test-guards-string-match-failure ()
  (should-error (guards-string-match! "hello" "^z")))

(ert-deftest test-guards-string-match-custom-signal ()
  (should-error (guards-string-match! "hello" "^z" 'custom-error-type)
                :type 'custom-error-type))

;;; Test for guards!
(ert-deftest test-guards-normal-operation ()
  (should (guards! t)))

(ert-deftest test-guards-failure ()
  (should-error (guards! nil)))

(ert-deftest test-guards-custom-signal ()
  (should-error (guards! nil 'custom-error-type)
                :type 'custom-error-type))

;;; guards-test.el ends here
