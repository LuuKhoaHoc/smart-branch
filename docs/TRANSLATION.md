# Translation Guide

Thank you for your interest in contributing translations to `smart-branch`! Here are the steps to add a new language.

## Translation Process

1.  **Copy an existing language file:**
    Make a copy of the `lang/en.sh` file and rename it with your language's [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) code.
    For example, if you are adding French, you would copy `lang/en.sh` to `lang/fr.sh`.

    ```bash
    cp lang/en.sh lang/fr.sh
    ```

2.  **Translate the strings:**
    Open your new language file (e.g., `lang/fr.sh`) and translate all the string values on the right side of the equals sign (`=`). Keep the variable names on the left unchanged.

    For example, in `lang/en.sh`:

    ```shell
    MSG_BRANCH_CREATION_SUCCESS="Successfully created branch"
    ```

    In `lang/fr.sh`, it would become:

    ```shell
    MSG_BRANCH_CREATION_SUCCESS="Branche créée avec succès"
    ```

3.  **Integrate the new language (Optional):**
    For the script to automatically detect and use your language, you need to add it to the language selection logic. This step is recommended but not required.

    - **In `smart-branch.sh`:**
      Navigate to the `detect_language` section and add your language code to the list of supported languages.
    - **In `install.sh`:**
      Similarly, update the language selection logic in the installation script to include your new language.

4.  **Submit a Pull Request:**
    Once you have completed the steps above, commit your changes and open a Pull Request on GitHub. We will review and merge your contribution.

Thank you for helping `smart-branch` reach more users around the world!
