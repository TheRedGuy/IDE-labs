IDE Laboratory Work #1 (extended)
=================================

Part 1: Setting server environment. Version Control.
----------------------------------------------------

### Objectives:
- Understanding and using CLI.
- Administration of a remote linux machine using SSH.
- Ability to work with Version Control Systems (GIT).
- Compile C/C++/Java/Python programs through CLI using gcc/g++/javac/python compilers.

This part of the laboratory work is presented in a screencast. 

[![Screencast](https://raw.github.com/TheRedGuy/IDE-labs/master/lab%231/movie.png)](https://vimeo.com/61480176)

Although I didn't provide any commentary in the video, I think everything is clear, and self-explanatory. 
I will only highlight the commands I used to complete the required tasks. 

- Connect to a server using SSH:  `ssh [username]@[hostname]`
- Compile C programms with gcc:   `gcc [source] -o [destination]`
- Initialize a GIT repository:    `git init`
- Add a change to staging:        `git add [filename]`
- Commit staging changes:         `git commit -m "[commit message]"`
- Clone a remote repository:      `git clone [remote repo]`
- Create a new branch:            `git branch [branch name]`
- Checkout into a branch:         `git checkout [branch name]`
- Merge a brange into current:    `git merge [branch name]`
- Add a remote:                   `git remote add [remote name] [remote repo]`
- Set a branch to track a remote: `git branch --track [remote repo/branch] [local branch]
- Reset to previous commit:       `git reset [mode] [commit]`

Part 2: Command Line Interface (CLI). Scripting.
------------------------------------------------

### Objectives:
- Understanding and using CLI.
- Ability to work remotely (remote code editing).
- Creating a script that will compile multiple projects (source codes) with resulting multiple programs

For this part of the laboratory work, I've developed a script that completes all the required tasks. 
It compiles and runs all the programs in "HelloWorldPrograms" directory. 
For programs that compiled successfuly, the script makes an empty commit with success message. 
For all the programs that failed to compile (or were interpreted with an error), the script gathers information, and sends
an email to a specified email, with the necesary information. 
The script also merges the "compilation-test" branch that it created into "master" branch.

Conclusion
----------

Although I was familiar to CLI (I compiled all my C/C++ lab works from the command line) and GIT workflow (using Github for a while now), I found this laboratory work to be quite interesting. 
Version Control Systems are useful tools, and using them can bring huge benefits to any development team. 
Also, knowing how to use `ssh` to connect to a server can crutial in some situations, and I'm glad that I learned it here. 
It was also quite fun developing the script. 
I look forward to next laboratory works.

