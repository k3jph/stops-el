;;; build-docs.el --- Build Stops documentation site -*- lexical-binding: t; -*-

;;; Commentary:

;; Export docs/index.org to public/index.html for GitHub Pages.

;;; Code:

(require 'org)
(require 'ox-html)

(setq org-confirm-babel-evaluate nil)
(setq org-export-with-broken-links t)
(setq org-html-doctype "html5")
(setq org-html-html5-fancy t)
(setq org-html-validation-link nil)
(setq org-html-head-include-default-style nil)
(setq org-html-head-include-scripts nil)
(setq org-html-use-infojs nil)
;; Do not require the external htmlize package during documentation builds.
;; This keeps the GitHub Pages artifact build deterministic under `emacs -Q'.
(setq org-html-htmlize-output-type nil)

(let* ((script (or load-file-name buffer-file-name))
       (root (file-name-directory
              (directory-file-name
               (file-name-directory script))))
       (source (expand-file-name "docs/index.org" root))
       (output-dir (expand-file-name "public" root))
       (output (expand-file-name "index.html" output-dir)))
  (make-directory output-dir t)
  (with-current-buffer (find-file-noselect source)
    (let ((default-directory (file-name-directory source))
          (org-export-show-temporary-export-buffer nil))
      (org-export-to-file 'html output)))
  (unless (file-exists-p output)
    (error "Documentation export failed: %s was not created" output)))

;;; build-docs.el ends here
