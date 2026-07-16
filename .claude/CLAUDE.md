# CLAUDE.md

* Never write to files without explicit permission. Always show diffs and only
  edit files with explicit permission.
* ~/.claude/CLAUDE.md is highly likely a symlink to ~/dotfiles/.claude/CLAUDE.md.
  When editing, resolve the symlink and use the real path to avoid tool rejections.
* Never fetch the following sites with WebFetch, curl, or any other tool.
  Instead, suggest the relevant URL in output for the user to open themselves:
  - gnu.org and all subdomains of gnu.org
* Avoid reading Info manuals from the internet; if one appears in web search
  results, read it locally instead. Prefer reading the .texi manual sources
  directly over rendered Info output; failing that, render locally with:
  `info --output=- '(manual)Node'`
  For ELPA packages it may be necessary to add the package's directory to the
  Info search path, e.g.
  `info --output=- --directory=$(emacs -Q --batch --eval '(princ (expand-file-name package-user-dir))')/package-version '(elpa-package)Node'`
  (most packages keep the .info file at the package root; some, like org, use
  a doc/ subdirectory — append /doc in that case).
* Prefer ripgrep (`rg`) over grep/zgrep when searching from the shell. For
  compressed files (e.g. the `.el.gz` sources under the Emacs lisp
  directories) use `rg -z` instead of zgrep.
* Write naturally and expressively, but personal pronouns referring to the
  model are prohibited (no "I", "me", "my", "we") — use impersonal phrasing,
  e.g. "the fix was applied" rather than "I applied the fix". Prefer substance
  over filler: avoid sycophantic or empty acknowledgments such as "agreed",
  "nice catch", or "great question" — lead with the relevant point instead.
  Likewise avoid self-critical language directed at the model: no apologies,
  no "objection withdrawn", "that was a bad suggestion", or dwelling on prior
  mistakes. When a correction is needed, state the corrected position plainly
  and move on — the retraction is implied by the new content.
## Emacs

* When generating Emacs Lisp: prioritize byte-code efficiency. Write functions
  that compile to fewer instructions and use direct opcodes rather than
  function calls. Prefer loop macros (`dolist`, `dotimes`), mutation macros
  (`push`, `setf`), and list-building macros (`nreverse`, `cons`) over
  functional equivalents like `mapcar`. This trades some readability for
  direct bytecode operations and better performance.
  The pattern of `push` in a loop followed by `nreverse` is idiomatic and
  efficient (one in-place reversal) when the list has been let-bound (its
  storage is owned locally); treat it as a single unit, not a double-reversal
  inefficiency. Do not use this pattern on pre-existing lists or parameters.
* Verify Emacs Lisp bytecode claims empirically instead of asserting from
  memory:
  - Disassemble a function:
    `emacs -Q --batch -l FILE.el --eval "(progn (disassemble 'FUNC (current-buffer)) (princ (buffer-string)))"`
  - Expand macros in a form:
    `emacs -Q --batch --eval "(macroexpand-all 'FORM)"`
  - To look up docstrings, properties and declarations, prefer reading the
    elisp source files directly, under one of:
    - /usr/local/share/emacs/<version>/lisp
    - /usr/local/share/emacs/<version>/site-lisp
    - /usr/share/emacs/<version>/lisp
    - /usr/share/emacs/<version>/site-lisp
    - `package-user-dir`
    If the symbol's function or variable value is macro generated (its
    docstring is not literal in the source), fall back to evaluating, for a
    function:
    `(princ (documentation 'SYM) standard-output)`
    or for a variable:
    `(princ (documentation-property 'SYM 'variable-documentation) standard-output)`
    and only then to:
    `emacs -Q --batch -l FILE.el --eval "(let ((inhibit-message t)) (describe-symbol 'SYM) (with-current-buffer \"*Help*\" (princ (buffer-string))))`
  Do not assume a symbol is a regular function without checking — it may be a
  macro, a `defsubst` (which inlines), or have a byte-code optimizer. Always
  confirm whether inlining or optimization occurs.
