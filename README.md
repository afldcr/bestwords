# bestwords

All of the best words.

## Generating the regular expression file

The Google Docs plugin uses `bestwords.regexp` rather than the word list
contained in `bestwords.txt` to match words. To update the regular expression
after updating the word list, run `./update-regexp` from the root directory.
