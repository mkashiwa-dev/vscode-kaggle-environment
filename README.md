# Visual Studio Code Kaggle Environment

A development environment for using the Kaggle CLI in a VS Code Dev Container to
download competition data, run experiments, generate predictions, and submit results.

## Project Structure

- `Dockerfile`: Uses the official Kaggle Python image as its base and installs additional packages
- `compose.yaml`: Starts the `app` service and mounts the repository at `/kaggle` inside the container
- `.devcontainer/devcontainer.json`: VS Code Dev Container configuration
- `requirements.txt`: Defines additional packages such as MLflow, Weights & Biases, Hydra, and the Kaggle CLI
- `competitions/`: Working directories for individual competitions

## Prerequisites

The documented setup has been tested on Ubuntu running under WSL2 with Docker.

- A host with an NVIDIA GPU and a working NVIDIA driver
- Docker Engine and the Docker Compose plugin installed in the WSL2 environment
- The NVIDIA Container Toolkit installed and configured for Docker. Follow the
    installation instructions in the [NVIDIA Container Toolkit
    repository](https://github.com/NVIDIA/nvidia-container-toolkit), then verify
    that `nvidia-smi` works on the host.
- VS Code with the Dev Containers extension installed
- A Kaggle account

## Setup

1. Open the [Kaggle Settings page](https://www.kaggle.com/settings) and generate an API token.
2. Create a `.env` file in the repository root and set the token:

   ```dotenv
   KAGGLE_API_TOKEN=your-kaggle-api-token
   ```

   `.env` is excluded from Git. Do not commit or share your API token.
   If your token is exposed, revoke it and generate a new one from the Kaggle Settings page.

3. Open the repository in VS Code and run `Dev Containers: Reopen in Container` from
    the Command Palette. This uses the checked-in `compose.yaml` to build and start
    the `app` service, mounts the repository at `/kaggle`, loads `.env`, and opens
    the container as the `kaggle` user.

The image is built on the first launch, and the packages defined in `requirements.txt` are installed.
GPU access is required: the Compose service reserves all available GPUs through
its NVIDIA device reservation. If the host driver or NVIDIA Container Toolkit is
not configured, the container will not start. After changing the GPU
configuration, run `Dev Containers: Rebuild Container` so the container is
recreated with the GPU attachment.

## Verify the Setup

Run the following commands in the Dev Container terminal:

The setup is complete when `pwd` returns `/kaggle`, the competition list is displayed, and GPU access is available.

```bash
pwd
python --version
kaggle --version
kaggle competitions list
nvidia-smi
python -c "import torch; print(torch.__version__); print(torch.version.cuda); print(torch.cuda.is_available())"
```

`nvidia-smi` must work inside the container, and the PyTorch package must report
a non-`None` CUDA version with `torch.cuda.is_available()` returning `True`.
Do not replace the base image with a CPU-only image or install a CPU-only
PyTorch build.

## Working with Competitions

Create a directory under `competitions/` for each competition. Use the competition slug,
the identifier included in the competition URL, as the directory name.

```bash
mkdir -p competitions/titanic
cd competitions/titanic

# Download and extract the data
kaggle competitions download -c titanic
unzip -o titanic.zip
```

Example working directory:

```text
competitions/
└── titanic/
    ├── train.csv
    ├── test.csv
    ├── notebook.ipynb
    └── src/
```

You can find the competition slug in the competition page URL. For example, the slug
for `https://www.kaggle.com/competitions/titanic` is `titanic`.

### Common CLI Commands

```bash
# List competition files
kaggle competitions files -c <competition-slug>

# Download data
kaggle competitions download -c <competition-slug> -p data

# Check your leaderboard position
kaggle competitions leaderboard -c <competition-slug> -v

# Submit a CSV file
kaggle competitions submit -c <competition-slug> -f submission.csv -m "first submission"
```

Submission file names, column names, and submission procedures vary by competition.
Always review the competition's rules, `Data`, and `Evaluation` pages.

## Adding or Updating Packages

After editing `requirements.txt`, run `Dev Containers: Rebuild Container` from the VS Code Command Palette
to rebuild the container.

## Security and Git

`.gitignore` excludes `.env` from Git. The `competitions/.gitignore` file excludes
all untracked files under `competitions/`, including downloaded competition data
and submission files, while keeping `competitions/.gitignore` itself. Files that
are already tracked are not affected by `.gitignore`, so make sure that API
tokens, downloaded data, and submissions do not contain personal or other
confidential information before committing or sharing the repository.

## License

This repository is released under the [MIT License](LICENSE).

This repository does not distribute a built Docker image. The Dockerfile
references the following third-party components, which are obtained separately
when the image is built:

- Kaggle Python GPU Docker image (`gcr.io/kaggle-gpu-images/python:latest`), licensed
    under the Apache License 2.0. See the [Kaggle docker-python repository](https://github.com/Kaggle/docker-python).
- Kaggle CLI (`kaggle==2.2.2`), licensed under the Apache License 2.0. See the
    [Kaggle CLI repository](https://github.com/Kaggle/kaggle-cli).

The MIT License applies only to the original files in this repository. The
licenses and notices of these third-party components apply to those components
separately. Users who build the Docker image are responsible for complying
with the applicable licenses of the components obtained during the build.

## References

- [Kaggle Docker Python](https://github.com/Kaggle/docker-python)
- [Kaggle CLI](https://github.com/Kaggle/kaggle-cli)
- [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-container-toolkit)