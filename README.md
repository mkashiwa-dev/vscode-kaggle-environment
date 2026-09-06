# Visual Studio Code Kaggle Environment

A development environment for using the Kaggle CLI in a VS Code Dev Container to
download competition data, run experiments, generate predictions, and submit results.
Using a Dev Container also makes it easier to manage containers through the VS Code
GUI and to manage the VS Code extensions used in the development environment.

## Prerequisites

The setup has been tested on Ubuntu running under WSL2 with Docker.

- A host with an NVIDIA GPU and a working NVIDIA driver
- At least 80 GB of free storage available; 100 GB or more is recommended
- Docker Engine and the Docker Compose plugin installed in the WSL2 environment
- The NVIDIA Container Toolkit installed and configured for Docker. Follow the
    installation instructions in the [NVIDIA Container Toolkit
    repository](https://github.com/NVIDIA/nvidia-container-toolkit), then verify
    that `nvidia-smi` works on the host.
- VS Code with the Dev Containers extension installed
- A Kaggle account

## Setup

1. Clone this repository:

    ```bash
    git clone https://github.com/mkashiwa-dev/vscode-kaggle-environment.git
    ```

2. Open the [Kaggle Settings page](https://www.kaggle.com/settings) and generate an API token.
3. Create a `.env` file in the repository root and set the token:

   ```bash
   echo "KAGGLE_API_TOKEN=your-kaggle-api-token" > .env
   ```

4. Open the repository in VS Code and run `Dev Containers: Reopen in Container`.

The image is built on first launch. GPU access is required; after changing
`requirements.txt` or GPU configuration, run `Dev Containers: Rebuild Container`.

## Verify the Setup

Run these commands in the Dev Container terminal:

```bash
pwd
python --version
kaggle --version
kaggle competitions list
nvidia-smi
python -c "import torch; print(torch.__version__); print(torch.version.cuda); print(torch.cuda.is_available())"
```

The setup is complete when `pwd` returns `/kaggle`, competitions are listed,
and `torch.cuda.is_available()` returns `True`.

## Working with Competitions

Create a directory under `competitions/` for each competition, using its URL slug:

```bash
mkdir competitions/titanic
cd competitions/titanic
kaggle competitions download -c titanic
unzip -o titanic.zip
```

You can find the competition slug in the competition page URL. For example, the slug
for `https://www.kaggle.com/competitions/titanic` is `titanic`.

## Security and Git

`.env` and untracked files under `competitions/` are ignored by Git. Never commit
API tokens or confidential data.

## License

This repository is released under the [MIT License](LICENSE). For third-party
components, see the [Kaggle Docker Python](https://github.com/Kaggle/docker-python),
[Kaggle CLI](https://github.com/Kaggle/kaggle-cli), and [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-container-toolkit)
repositories.