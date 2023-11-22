# Demo station setup

Instructions are here:
- https://github.com/eti-tme-org/....

## Laptop preparations

Instructions assume MacOS based demo stations.  A few of these commands need to be copied and pasted from the GitHub repo web page into a local Terminal for execution as a bootstrap to get required components.

### MacOS preparations

- Install Command Line Tools for Xcode

```bash
xcode-select --install
```

### Repository Cloning

Clone the demo repository and all of its submodules:

``bash
git clone --recurse-submodules https://github.com/eti-tme-org/apisec-cicd-demo
```

From this point, all the instructions are local to the laptop in the [setup README](setup/README.md):

```bash
cd apisec-cicd-demo/setup
cat README.md
```

### MacOS pre-requisites

Install [Homebrew](https://brew.sh) using the following command. For safety's sake, you should go to their site and verify the command is the same (it's on the main page):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

You will be prompted for a password to be able to sudo and install the important components.  You'll also need to update the shell environment according to the instructions provided (default MacOS shell is ZSH):

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' > ${HOME}/.zprofile
```

Open a new terminal and verify the Homebrew paths are working via:

```bash
brew update
```

### Demo Pre-requisites Installation

Install the dependencies from Homebrew

```bash
# Should still be in (apisec-cicd-demo)/setup directory
brewfile bundle install -f Brewfile
```

### Panoptica Components

These components are available from the Panoptica service, using the demo tenant, at https://panoptica.app. As part of the conference exhibit booth, a set of static, read-only credentials should have been provided.

- Log into Panoptica and navigate to the [API Security Setting](https://console.panoptica.app/settings/api_sec).

- Select the proper platform from the drop down list (MacOS Apple Silicon, most likely correct) and download the CLI. This file should be stored in the [container](../container/) folder.

- Copy the two keys that are presented in the window and add them to the [config/cicd.api.keys](../config/cicd.api.keys) file.

### Complete the container-based demo environment

Follow the [instructions](../container/README.md) on how to build and operate the container.
