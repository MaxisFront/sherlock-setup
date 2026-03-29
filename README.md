# sherlock-setup
Bash tool for HTB Sherlock challenges.

## What is it about?
This is an automation tool for HTB Sherlock challenges. Sets up the directory environment, downloads and extracts the challenge files. A simple Quality of Life script.

> [!NOTE]
> - Semi-DFIR structure: Creates the main directory with the `Machine Name` and the subdirectories `/artifacts`, `/exports`, `/logs` and `/src`.
> - Downloads the .zip, generates its `SHA256` hash and moves both to the `/src` directory.
> - Extracts the .zip content into `/artifacts`.
> - The script automatically identifies if it's a standalone or a function.

## Prerequisites

> [!NOTE]
> You need the following tools in your system:
> - 7z
> - wget
> - sha256sum

The script can be executed like a **_standalone binary_** or you can add it to your `~/.bashrc` or `~/.zshrc` config file.

## Installation
You can download and make it executable with the following commands:

```ruby
wget "https://raw.githubusercontent.com/MaxisFront/sherlock-setup/refs/heads/main/sherlock-setup.sh"
chmod +x sherlock-setup.sh
```

## Usage

The parameters needed for the script are as follows 

```ruby
sherlock-setup <MachineName> <ZIP-URL> [PASSWORD]
```

> [!IMPORTANT]
> - The password by default is `hacktheblue`. If HTB changes it, you can add it as a third parameter if you want to.

Example:

```ruby
sherlock-setup Brutus "https://labs.hackthebox.com/api/v4/challenges/631/cdn/redirect?auth_user_id=49439534&expires=32482394234&signature=34e1fe0df943534cad3936803ea609ba345345e4ac99ffc5dbf34534541fbe2f"
```
