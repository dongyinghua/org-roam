;;; packages.el --- org-roam layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2021 Sylvain Benner & Contributors
;;
;; Author: 英华董 <yinghuadong@yinghuaongdeMBP>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `org-roam-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `org-roam/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `org-roam/pre-init-PACKAGE' and/or
;;   `org-roam/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst org-roam-packages
  '(
     org-roam
     org-roam-bibtex
     ))
;;org-roam-server)

(defun org-roam/init-org-roam ()
  (use-package org-roam
    :defer t
    :hook (after-init . org-roam-mode)
    :init
    (setq org-roam-v2-ack t)
    :custom
    (org-roam-directory "~/Documents/org-roam/") ;; please change it to your path
    :config
    (progn
      (spacemacs/declare-prefix "aor" "org-roam")
      (spacemacs/declare-prefix "aord" "org-roam-dailies")
      (spacemacs/declare-prefix "aort" "org-roam-tags")
      (spacemacs/set-leader-keys
        "aordy" 'org-roam-dailies-goto-yesterday
        "aordt" 'org-roam-dailies-goto-today
        "aordT" 'org-roam-dailies-goto-tomorrow
        "aordd" 'org-roam-dailies-goto-date
        "aor/" 'org-roam-node-find
        "aorc" 'org-roam-capture
        ;; "aorg" 'org-roam-graph
        "aori" 'org-roam-node-insert
        "aorl" 'org-roam-buffer-toggle
        "aorta" 'org-roam-tag-add
        "aortd" 'org-roam-tag-delete
        "aora" 'org-roam-alias-add)

      (spacemacs/declare-prefix-for-mode 'org-mode "mr" "org-roam")
      (spacemacs/declare-prefix-for-mode 'org-mode "mrd" "org-roam-dailies")
      (spacemacs/declare-prefix-for-mode 'org-mode "mrt" "org-roam-tags")
      (spacemacs/set-leader-keys-for-major-mode 'org-mode
        "rb" 'org-roam-switch-to-buffer
        "rdy" 'org-roam-dailies-goto-yesterday
        "rdt" 'org-roam-dailies-goto-today
        "rdT" 'org-roam-dailies-goto-tomorrow
        "rdd" 'org-roam-dailies-goto-date
        "r/" 'org-roam-node-find
        "rc" 'org-roam-capture
        ;; "rg" 'org-roam-graph
        "ri" 'org-roam-node-insert
        "rl" 'org-roam-buffer-toggle
        "rta" 'org-roam-tag-add
        "rtd" 'org-roam-tag-delete
        "ra" 'org-roam-alias-add))
    (setq org-roam-mode-sections
      (list #'org-roam-backlinks-insert-section
        #'org-roam-reflinks-insert-section
        ))
    (setq org-roam-file-extensions '("org"))
    (org-roam-setup)

    ;; templates
    (setq org-roam-capture-templates
      '(
         ("d" "default" plain
           "%?"
           :if-new (file+head "${slug}.org"
                     "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
         ("r" "ref" plain
           "%?"
           :if-new (file+head "./ref_notes/${slug}.org"
                     "#+title: ${title}\n")
           :unnarrowed t)))
    (setq org-roam-dailies-directory "daily/")
    (setq org-roam-dailies-capture-templates
      '(("d" "default" entry
          "* %?"
          :if-new (file+head "%<%Y-%m-%d>.org"
                    "#+title: %<%Y-%m-%d>\n"))))
    ))

(defun org-roam/init-org-roam-bibtex ()
  (use-package org-roam-bibtex
    :after org-roam
    :config
    :hook (org-roam-mode . org-roam-bibtex-mode)
    )
  )
