# Quick Safe Backups (QSB) #

Create safe backups for your important folders and store them in the cloud and external hard drives.

# Why use QSB #

In case of disaster, you'll want to have up-to-date backups of your important folders in several remote locations (ideally of different nature, such as cloud services and external hard drives).

You'll also want backups in different locations not to be "in sync" with one another (even while holding identical information). This way you'll ensure that corruption in one location will not propagate to other locations.

QSB handles all of this automatically on the press of a button.

#### Overview ####

* **Quick**: Copy over byte differences when replicating your backups (avoid full replication).
* **Safe**: 'One-Way synchronization' between your local files and the backups stored in the cloud. This means that if someone gains access to any of your cloud accounts, any changes made will not propagate to your local files (or anywhere else).
* **Timeline**: Easily revert to an earlier state of your important folder.
* **Clarity**: Get records indicating i. where your backups are stored, ii. how up to date they are in each location, and iii. the original source directory for each backup.

QSB is most useful with <ins>fast changing directories which aren't too heavy</ins> (e.g.: many text files, documents, spreadsheets, some images...). These folders would typically hold important information where you wouldn't want to lose any of your progress.

QSB works on <ins>Mac</ins> and <ins>Linux</ins>. It is written as a series of <ins>bash</ins> scripts.

# How it works #

1. **You'll specify your sources in text file `sources.txt`**  
    Sources are the directories in your local machine that you would like to back up
2. **You'll specify your targets in text file `targets.txt`**  
    Targets are the places where you would like to replicate the backups for your sources (e.g.: Dropbox, Google Drive, an external hard drive...)
3. **QSB places backups for your sources inside a special directory in your local machine**  
    (By default: a folder named `backups` in your home directory)
    * Each backup consists of a zip file, capturing the sate of the original source folder at a specific moment in time
        * The name of each zip file will reflect the time and date of the backup  
            E.g.: `my_folder-bak-2021-09-22T14-03.zip`
        * This will allow you to easily revert to a prior state of your source directory if you need to
    * Each source gets its own subdirectory inside the backups directory  
        This keeps things clear and makes it easy to find any particular backup
    * By default, QSB makes sure to keep no more than the 5 most recent backups of each source (you can increase this number up to a max. of 25)  
        This way you won't have to worry about the backups folder getting too big
4. **QSB replicates the entire backups directory into each of the specified targets**  
    * This is done efficiently, as it only copies over changes between the backups directory and the target
    * If a target cannot be found, QSB will skip replication of backups for this target and keep going  
        E.g.: one of your targets may be an external hard drive, which isn't always connected to your machine. QSB will replicate backups to this target whenever it is able to. If it isn't able, it will simply indicate so and keep replicating backups into other targets
    * QSB produces a `replications.log` (inside your backups directory) which will help you understand *when* and *where to* your backups have been replicated

# Getting Started (Quick Setup) #

1. **Download this repository**

    1. Press the green button that says `Code` in the [repo's landing page](https://github.com/jaroxe/quick-safe-backups)
    2. Then press `Download ZIP` (go ahead and download it into your `Downloads` folder)
    3. Go to your `Downloads` folder and extract the contents of the zip file. You should now have a folder named `quick-safe-backups-main` inside your `Downloads` folder

2. **Append the following snippet to the end of your `.bash_profile`** (or equivalent)

    ```
    export QSB_WHERE="${HOME}/Downloads/quick-safe-backups-main"
    alias qsb='sh "${QSB_WHERE}/master.sh"'
    ```

    **NOTE**: if you have no clue what this means, or you're not sure what the appropriate equivilent file would be in your case, do not panic. Scroll down to the next section (*Full Configuration*).

3. **Add some source directories inside `sources.txt`** (one source per line)

    Example `sources.txt`:

    ```
    /Users/my_user_name/Documents/my_first_folder
    /Users/my_user_name/Desktop/my_second_folder
    ```

4. **Add some target locations inside `targets.txt`** (one target per line)

    This is most useful when your target paths represent: i) local folders which are synced with the cloud, ii) cloud services which are accessible from your computer, or iii) external hard drives.

    Example `targets.txt`:

    ```
    /Users/my_user_name/Dropbox
    /Volumes/GoogleDrive/My Drive
    /Volumes/myExtHDD
    ```

5. **Run QSB**
    Type `qsb` into your Terminal and press `⏎`

# Full configuration #

The behavior of QSB is determined by several files:

## `.bash_profile` (or equivalent) ##

**_"Wait, what on earth is .bash_profile?"_**  
Think of it this way: *bash* is a language you can use to communicate with your computer (this type of language is known as *shell*). QSB is written in this language. `bash_profile` is a configuration file for this language. Our goal here is to tell *bash* a couple of things about QSB through `.bash_profile` (or some equivalent file; please keep on reading).

**macOS**  
Starting on version 10.15 (Catalina), macOS changed its default *shell* from *bash* to *zsh*. You should find out which shell your system is running (by default) before proceeding with this part of the configuration.
Open up the terminal and run the following command:

```
echo $0
```

* if the terminal returned `-bash` (or similar) you may ignore the following point

* if the terminal returned `-zsh` (or similar), you have two options:

    * the safest option is to use `.zshenv` as your equivalent for `.bash_profile`: in the instructons that follow, replace any references to `.bash_profile` with `.zshenv` and you'll be fine

    * alternatively, you can change the default *shell* of your system to *bash* with the following command:

        ```
        chsh -s /bin/bash
        ```

**Linux**  
If [your OS is Ubuntu](https://askubuntu.com/questions/510709/i-cannot-find-bash-profile-in-ubuntu), chances are *bash* will be using the more generic `.profile` to configure its environment (this may be true of other Linux distros).  
I'd recommend doing the following to be on the safe side:

1. Check whether `.bash_profile` is present in your home directory.
    `.bash_profile` is a hidden file. You can list out all files in your home directory (including hidden files) by running the following command on the terminal:

    ```
    ls -a ${HOME}
    ```

2. If `.bash_profile` is present in your home directory, stick with it (ignore step 3)

3. Otherwise, you should use `.profile` as your equivalent for `.bash_profile`: in the instructons that follow, replace any references to `.bash_profile` with `.profile` and you'll be fine

**Let's jump into it**  
So now we know: `.bash_profile` is a hidden file located in your home directory. We need to edit this file by adding the following snippet:

```
export QSB_WHERE="${HOME}/Downloads/quick-safe-backups-main"
alias qsb='sh "${QSB_WHERE}/master.sh"'
```

You can easily open this file from the terminal by running:

```
nano ~/.bash_profile
```

Scroll down to the bottom of the file (use arrow keys) and copy/paste the snippet. (It's fine if this file is completely empty or didn't previously exist; `nano` will create this file for you when you quit and save your changes).

**Making sure it worked**  

1. Quit `nano` and save your changes (type `⌃X` to quit, `Y` to save changes, and `⏎` to confirm the file name)

2. End your terminal session (run `exit`) and quit the program (`⌘Q`)

3. Reopen the terminal and run this command:

    ```
    echo ${QSB_WHERE}
    ```

    If everything worked correctly this command should print out the path to your QSB folder (insider your Downloads directory).

4. You can check that QSB is working by running it on your terminal (it's okay if you have no sources or targets for now):

    ```
    qsb
    ```

**Understanding and modifying the snippet**  

```
export QSB_WHERE="${HOME}/Downloads/quick-safe-backups-main"
alias qsb='sh "${QSB_WHERE}/master.sh"'
```

<ins>The **first line** tells *bash* where in your local machine it should run QSB from</ins>

You can try the following example:

Move the QSB folder outside of `Downloads` and into your `Documents` folder. Also, rename the folder from `quick-safe-backups-main` to the cleaner `quick-safe-backups`.  
After you've done this you will need to let *bash* know about these changes; modify the first line in the snippet (in `.bash_profile`):

```
export QSB_WHERE="${HOME}/Documents/quick-safe-backups"
```

<ins>The **second line** tells bash which command you'd like to use to run QSB from the terminal</ins>

By default, this command is `qsb`. If you wanted, you could change this command to something different, such as `run_qsb` (more explicit), `bak` (short for backups)... it's up to you.

Example: if you wanted to run QSB with command `bak` (instead of `qsb`), you'd simply change "qsb" to "bak" on the second line of the snippet (in `.bash_profile`):

```
alias bak='sh "${QSB_WHERE}/master.sh"'
```

## `config.cfg` ##

This file contains configuration parameters in the form `PARAMETER=VALUE`.

* `BACKUPS_PATH`: full path to the directory where backups generated by QSB will be saved in your local machine. Change the value of this parameter to change the location and/or name of the backups directory.
* `KEEP_X_LAST_BACKUPS`: this is the maximum number of backups QSB will hold on disc for any particular source. Accepted values for this parameter are integers between 1 and 25 (both inclussive). QSB keeps newer backups and deletes older ones.

## `config.cfg.defaults` ##

This file is similar to `config.cfg`. It contains default values for configuration parameters. Unlike `config.cfg` this file should not be edited. If a parameter is commented out in `config.cfg`, QSB will read the default value for the parameter from `config.cfg.defaults`.

## `sources.txt` ##

This file must be entirely filled out by you, the user. It should include the full path to each directory that you would like to back up (one per line).

Example `sources.txt`:

```
/Users/my_user_name/Documents/my_first_folder
/Users/my_user_name/Desktop/my_second_folder
```

Typically, your sources will be directories hosted in your local machine. However, you could also include folders hosted elsewhere, as long as they are accessible from your computer (the cloud, external hard drives...).

Sources don't need to be accessible at all times. If a source isn't found during the backup process, QSB will simply skip it and attempt to back it up next time around (as long as it remains in `sources.txt`).

## `targets.txt` ##

This file must be entirely filled out by you, the user. It should include the full path to each location where you would like to replicate your backups (one per line).

Useful targets are locations that are accessible from your computer but hosted outside of it.  
Common cases:

* **Local folders which are synced with the cloud**  
    Example: '`${HOME}/Dropbox`' (a standard installation of Dropbox will provide you with this kind of folder)
* **Cloud services which are accessible from your computer**  
    Example: '`/Volumes/GoogleDrive/My Drive`'  
    (tip: use Google Drive for Desktop and select option `Stream files` in Preferences)
* **External hard drives**  
    Example: '`/Volumes/myExtHDD`'

Example `targets.txt`:

```
/Users/my_user_name/Dropbox
/Volumes/GoogleDrive/My Drive
/Volumes/myExtHDD
```

Notes:

* QSB will replicate the entire `backups` directory (see `config.cfg`) into the specified targets, even when some/all of that content is not generated by QSB (e.g.: things you manually save or move into the backups directory). You may want to use this to your advantage.
* If QSB cannot find a given target during the replication process, it will simply skip it and attempt to replicate to it the next time around (as long as it remains in `targets.txt`).

# Code Structure #

`master.sh` is the entry file to the system; running this file will call up other files as needed:

* `master.sh`
    * `validate_config.sh`
        * `config.shlib`
            * `config.cfg`
            * `config.cfg.defaults`
    * `back_up_all_sources.sh`
        * user inputs: `sources.txt`
        * inside loop: `back_up_one_source.sh`
    * `replicate_backups_in_all_targets.sh`
        * user inputs: `targets.txt`
        * inside loop: `replicate_backups_in_one_target.sh`

Note: all `.sh` files call `config.shlib`, but it is most central to `validate_config.sh`.
