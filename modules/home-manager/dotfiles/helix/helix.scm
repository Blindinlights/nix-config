(require "helix/editor.scm")
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))

(provide shell
         git-add
         copy-current-path
         copy-current-position
         selection-upcase
         selection-downcase
         selection-smart-case
         selection-toggle-case
         selection-toggle-bool
         markdown-link-selection
         trim-and-copy-selection
         open-helix-scm
         open-init-scm
         cargo
         cargo-add
         cargo-add-features
         cargo-remove
         cargo-build
         cargo-build-release
         cargo-check
         cargo-clippy
         cargo-fmt
         cargo-test
         cargo-test-nearest
         cargo-run
         cargo-run-release
         cargo-doc
         cargo-doc-open
         cargo-clean
         cargo-update
         cargo-tree)

(define (current-path)
  (let* ([focus (editor-focus)]
         [focus-doc-id (editor->doc-id focus)])
    (editor-document->path focus-doc-id)))

(define (current-path-or-empty)
  (let ([path (current-path)])
    (if path path "")))

(define (clipboard-value)
  (let ([values (register->value #\+)])
    (if (null? values) "" (car values))))

(define (current-location)
  (string-append
    (current-path-or-empty)
    ":"
    (number->string (+ 1 (helix.static.get-current-line-number)))
    ":"
    (number->string (+ 1 (helix.static.get-current-column-number)))))

(define (replace-current-selection f)
  (helix.static.replace-selection-with
    (f (helix.static.current-highlighted-text!))))

(define (surround-selection left right)
  (replace-current-selection
    (lambda (text) (string-append left text right))))

(define (char-code c)
  (char->integer c))

(define (char-between? c low high)
  (and (>= (char-code c) (char-code low))
       (<= (char-code c) (char-code high))))

(define (ascii-upper? c)
  (char-between? c #\A #\Z))

(define (ascii-lower? c)
  (char-between? c #\a #\z))

(define (ascii-digit? c)
  (char-between? c #\0 #\9))

(define (ascii-alpha? c)
  (or (ascii-upper? c) (ascii-lower? c)))

(define (char-toggle-case c)
  (cond
    [(ascii-upper? c) (integer->char (+ (char-code c) 32))]
    [(ascii-lower? c) (integer->char (- (char-code c) 32))]
    [else c]))

(define (smart-case text)
  (list->string (map char-toggle-case (string->list text))))

(define (whitespace? c)
  (or (equal? c #\space)
      (equal? c #\tab)
      (equal? c #\newline)
      (equal? c #\return)))

(define (identifier-char? c)
  (or (ascii-alpha? c)
      (ascii-digit? c)
      (equal? c #\_)))

(define (string-starts-with? text prefix)
  (let loop ([chars (string->list text)]
             [prefix-chars (string->list prefix)])
    (cond
      [(null? prefix-chars) #true]
      [(null? chars) #false]
      [(equal? (car chars) (car prefix-chars))
       (loop (cdr chars) (cdr prefix-chars))]
      [else #false])))

(define (chars-starts-with? chars prefix-chars)
  (cond
    [(null? prefix-chars) #true]
    [(null? chars) #false]
    [(equal? (car chars) (car prefix-chars))
     (chars-starts-with? (cdr chars) (cdr prefix-chars))]
    [else #false]))

(define (string-contains? text needle)
  (let ([needle-chars (string->list needle)])
    (if (null? needle-chars)
        #true
        (let loop ([chars (string->list text)])
          (cond
            [(null? chars) #false]
            [(chars-starts-with? chars needle-chars) #true]
            [else (loop (cdr chars))])))))

(define (string-trim-left text)
  (let loop ([chars (string->list text)])
    (cond
      [(null? chars) ""]
      [(whitespace? (car chars)) (loop (cdr chars))]
      [else (list->string chars)])))

(define (split-lines text)
  (let loop ([chars (string->list text)]
             [current '()]
             [lines '()])
    (cond
      [(null? chars)
       (reverse (cons (list->string (reverse current)) lines))]
      [(equal? (car chars) #\newline)
       (loop (cdr chars) '() (cons (list->string (reverse current)) lines))]
      [else
       (loop (cdr chars) (cons (car chars) current) lines)])))

(define (line-tokens line)
  (define (finish-token current tokens)
    (if (null? current)
        tokens
        (cons (list->string (reverse current)) tokens)))
  (let loop ([chars (string->list line)]
             [current '()]
             [tokens '()])
    (cond
      [(null? chars) (reverse (finish-token current tokens))]
      [(identifier-char? (car chars))
       (loop (cdr chars) (cons (car chars) current) tokens)]
      [else
       (loop (cdr chars) '() (finish-token current tokens))])))

(define (fn-name-from-tokens tokens)
  (cond
    [(null? tokens) #false]
    [(null? (cdr tokens)) #false]
    [(equal? (car tokens) "fn") (cadr tokens)]
    [else (fn-name-from-tokens (cdr tokens))]))

(define (rust-fn-name line)
  (let ([trimmed (string-trim-left line)])
    (if (string-starts-with? trimmed "//")
        #false
        (fn-name-from-tokens (line-tokens trimmed)))))

(define (rust-test-attribute? line)
  (let ([trimmed (string-trim-left line)])
    (and
      (string-starts-with? trimmed "#[")
      (or (string-starts-with? trimmed "#[test]")
          (string-starts-with? trimmed "#[test(")
          (string-contains? trimmed "::test]")
          (string-contains? trimmed "::test(")))))

(define (rust-attribute-line? line)
  (string-starts-with? (string-trim-left line) "#["))

(define (blank-line? line)
  (equal? (string-trim-left line) ""))

(define (rust-tests-in-lines lines)
  (let loop ([remaining lines]
             [line-number 0]
             [pending-test? #false]
             [tests '()])
    (if (null? remaining)
        (reverse tests)
        (let* ([line (car remaining)]
               [test-attr? (rust-test-attribute? line)]
               [fn-name (rust-fn-name line)])
          (cond
            [(and fn-name (or pending-test? test-attr?))
             (loop (cdr remaining)
                   (+ line-number 1)
                   #false
                   (cons (cons line-number fn-name) tests))]
            [fn-name
             (loop (cdr remaining) (+ line-number 1) #false tests)]
            [test-attr?
             (loop (cdr remaining) (+ line-number 1) #true tests)]
            [(rust-attribute-line? line)
             (loop (cdr remaining) (+ line-number 1) pending-test? tests)]
            [(blank-line? line)
             (loop (cdr remaining) (+ line-number 1) pending-test? tests)]
            [else
             (loop (cdr remaining) (+ line-number 1) #false tests)])))))

(define (nearest-test-name tests cursor-line)
  (let loop ([remaining tests]
             [previous #false])
    (cond
      [(null? remaining) (if previous (cdr previous) #false)]
      [(<= (car (car remaining)) cursor-line)
       (loop (cdr remaining) (car remaining))]
      [previous (cdr previous)]
      [else (cdr (car remaining))])))

(define (file->lines path)
  (split-lines (read-port-to-string (open-input-file path))))

(define (string-ends-with? text suffix)
  (let ([text-len (string-length text)]
        [suffix-len (string-length suffix)])
    (and (>= text-len suffix-len)
         (equal? (substring text (- text-len suffix-len) text-len) suffix))))

(define (current-rust-test-name)
  (let ([path (current-path)])
    (if (and path (string-ends-with? path ".rs"))
        (nearest-test-name
          (rust-tests-in-lines (file->lines path))
          (helix.static.get-current-line-number))
        #false)))

(define (shell-message text)
  (helix.run-shell-command (string-append "printf '" text "\\n'")))

;;@doc
;; Copy the current buffer path into the system clipboard register.
(define (copy-current-path)
  (set-register! #\+ (list (current-path-or-empty))))

;;@doc
;; Copy path:line:column for the current cursor into the system clipboard register.
(define (copy-current-position)
  (set-register! #\+ (list (current-location))))

;;@doc
;; Uppercase the current selection.
(define (selection-upcase)
  (replace-current-selection string-upcase))

;;@doc
;; Lowercase the current selection.
(define (selection-downcase)
  (replace-current-selection string-downcase))

;;@doc
;; Toggle ASCII letter case in the current selection; leave all other characters unchanged.
(define (selection-smart-case)
  (replace-current-selection smart-case))

;;@doc
;; Alias for selection-smart-case.
(define (selection-toggle-case)
  (selection-smart-case))

(define (toggle-bool-text text)
  (cond
    [(equal? text "true") "false"]
    [(equal? text "false") "true"]
    [(equal? text "True") "False"]
    [(equal? text "False") "True"]
    [(equal? text "TRUE") "FALSE"]
    [(equal? text "FALSE") "TRUE"]
    [(equal? text "yes") "no"]
    [(equal? text "no") "yes"]
    [(equal? text "on") "off"]
    [(equal? text "off") "on"]
    [(equal? text "0") "1"]
    [(equal? text "1") "0"]
    [else text]))

;;@doc
;; Toggle selected boolean-ish text: true/false, yes/no, on/off, 0/1.
(define (selection-toggle-bool)
  (replace-current-selection toggle-bool-text))

;;@doc
;; Wrap the current selection as a Markdown link using the clipboard register as the URL.
(define (markdown-link-selection)
  (surround-selection "[" (string-append "](" (clipboard-value) ")")))

;;@doc
;; Trim the current selections and yank them to the system clipboard.
(define (trim-and-copy-selection)
  (helix.static.trim_selections)
  (helix.static.yank_joined_to_clipboard))

;;@doc
;; Specialized shell implementation, where % is a wildcard for the current file
(define (shell . args)
  (helix.run-shell-command
    (string-join
      ;; Replace the % with the current file
      (map (lambda (x) (if (equal? x "%") (current-path) x)) args)
      " ")))

;;@doc
;; Adds the current file to git	
(define (git-add)
  (shell "git" "add" "%"))

(define (cargo . args)
  (apply shell (cons "cargo" args)))

(define (cargo-add . crates)
  (apply cargo (cons "add" crates)))

(define (cargo-add-features crate . features)
  (cargo "add" crate "--features" (string-join features ",")))

(define (cargo-remove crate)
  (cargo "remove" crate))

(define (cargo-build)
  (cargo "build"))

(define (cargo-build-release)
  (cargo "build" "--release"))

(define (cargo-check)
  (cargo "check"))

(define (cargo-clippy)
  (cargo "clippy"))

(define (cargo-fmt)
  (cargo "fmt"))

(define (cargo-test)
  (cargo "test"))

;;@doc
;; Run the nearest Rust test function at or above the cursor.
(define (cargo-test-nearest)
  (let ([test-name (current-rust-test-name)])
    (if test-name
        (cargo "test" test-name)
        (shell-message "cargo-test-nearest: no Rust test found"))))

(define (cargo-run)
  (cargo "run"))

(define (cargo-run-release)
  (cargo "run" "--release"))

(define (cargo-doc)
  (cargo "doc"))

(define (cargo-doc-open)
  (cargo "doc" "--open"))

(define (cargo-clean)
  (cargo "clean"))

(define (cargo-update)
  (cargo "update"))

(define (cargo-tree)
  (cargo "tree"))

;;@doc
;; Open the helix.scm file
(define (open-helix-scm)
  (helix.open (helix.static.get-helix-scm-path)))

;;@doc
;; Opens the init.scm file
(define (open-init-scm)
  (helix.open (helix.static.get-init-scm-path)))
  
	
