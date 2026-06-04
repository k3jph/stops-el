;;; stops-test.el --- Tests for stops.el -*- lexical-binding: t; -*-

;;; Commentary:

;; ERT tests for stops.el.

;;; Code:

(require 'ert)
(require 'cl-lib)
(require 'stops)

(define-error 'stops-test-error "Stops test error")

(defun stops-test--error-message (form)
  "Evaluate FORM and return its error message."
  (condition-case err
      (eval form lexical-binding)
    (error (error-message-string err))))

;; Tests for `stops-if!'.

(ert-deftest stops-if/signals-default-error ()
  (should-error (stops-if! t) :type 'error))

(ert-deftest stops-if/signals-custom-error ()
  (should-error (stops-if! t :error-type 'stops-test-error)
                :type 'stops-test-error))

(ert-deftest stops-if/uses-custom-message ()
  (should (equal (stops-test--error-message
                  '(stops-if! t :error-message "custom message"))
                 "custom message")))

(ert-deftest stops-if/uses-custom-error-and-message ()
  (should
   (equal (condition-case err
              (stops-if! t
                :error-type 'stops-test-error
                :error-message "custom message")
            (stops-test-error (cdr err)))
          '("custom message"))))

(ert-deftest stops-if/uses-default-message ()
  (should (string-match-p
           "stops-if!: condition was non-nil: t"
           (stops-test--error-message '(stops-if! t)))))

(ert-deftest stops-if/returns-t-when-condition-is-nil ()
  (should (eq (stops-if! nil) t)))

(ert-deftest stops-if/evaluates-message-once ()
  (let ((n 0))
    (should-error
     (stops-if! t
       :error-message (progn
                        (cl-incf n)
                        "custom message")))
    (should (= n 1))))

(ert-deftest stops-if/does-not-evaluate-message-when-guard-passes ()
  (let ((n 0))
    (should (eq (stops-if! nil
                  :error-message (progn
                                   (cl-incf n)
                                   "custom message"))
                t))
    (should (= n 0))))

;; Tests for `stops-if-not!'.

(ert-deftest stops-if-not/signals-default-error ()
  (should-error (stops-if-not! nil) :type 'error))

(ert-deftest stops-if-not/signals-custom-error ()
  (should-error (stops-if-not! nil :error-type 'stops-test-error)
                :type 'stops-test-error))

(ert-deftest stops-if-not/uses-custom-message ()
  (should (equal (stops-test--error-message
                  '(stops-if-not! nil :error-message "custom message"))
                 "custom message")))

(ert-deftest stops-if-not/uses-custom-error-and-message ()
  (should
   (equal (condition-case err
              (stops-if-not! nil
                :error-type 'stops-test-error
                :error-message "custom message")
            (stops-test-error (cdr err)))
          '("custom message"))))

(ert-deftest stops-if-not/uses-default-message ()
  (should (string-match-p
           "stops-if-not!: condition was nil: nil"
           (stops-test--error-message '(stops-if-not! nil)))))

(ert-deftest stops-if-not/returns-t-when-condition-is-non-nil ()
  (should (eq (stops-if-not! t) t)))

(ert-deftest stops-if-not/evaluates-message-once ()
  (let ((n 0))
    (should-error
     (stops-if-not! nil
       :error-message (progn
                        (cl-incf n)
                        "custom message")))
    (should (= n 1))))

(ert-deftest stops-if-not/does-not-evaluate-message-when-guard-passes ()
  (let ((n 0))
    (should (eq (stops-if-not! t
                  :error-message (progn
                                   (cl-incf n)
                                   "custom message"))
                t))
    (should (= n 0))))

(ert-deftest stops-if/uses-formatted-message ()
  (should
   (equal (condition-case err
              (let ((x 10))
                (stops-if! t
                  :error-message (format "Cannot divide %S by zero" x)))
            (error (error-message-string err)))
          "Cannot divide 10 by zero")))

(ert-deftest stops-if-not/uses-formatted-message ()
  (should
   (equal (condition-case err
              (let ((x "nope"))
                (stops-if-not! (integerp x)
                  :error-message (format "Expected integer, got %S" x)))
            (error (error-message-string err)))
          "Expected integer, got \"nope\"")))

(provide 'stops-test)

;;; stops-test.el ends here
