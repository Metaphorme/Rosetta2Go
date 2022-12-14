# Rosetta

[![BuildForDocker](https://github.com/Metaphorme/Rosetta2Go/actions/workflows/BuildForDocker.yml/badge.svg)](https://github.com/Metaphorme/Rosetta2Go/actions/workflows/BuildForDocker.yml)
[![BuildForSingularity](https://github.com/Metaphorme/Rosetta2Go/actions/workflows/BuildForSingularity.yml/badge.svg)](https://github.com/Metaphorme/Rosetta2Go/actions/workflows/BuildForSingularity.yml)
[![RosettaVersion](https://img.shields.io/badge/Rosetta-3.13/lastest-green)](https://www.rosettacommons.org/docs/latest/release-notes/)
[![OpenMPIVersion](https://img.shields.io/badge/Open%20MPI-4.14/lastest-green)](https://www.open-mpi.org/)
[![License](https://img.shields.io/github/license/Metaphorme/Rosetta2Go?logo=opensourceinitiative)](https://metaphorme.github.io/Rosetta2Go/LICENSE)

The [Rosetta software suite](https://www.rosettacommons.org/) includes algorithms for computational modeling and analysis of protein structures. It has enabled notable scientific advances in computational biology, including de novo protein design, enzyme design, ligand docking, and structure prediction of biological macromolecules and macromolecular complexes.

Rosetta is available to all non-commercial users for free and to commercial users for a fee.

This is a Docker/Singularity image of Rosetta with **MPI supported**, which helps you to setup rosetta quickly on different platforms.

**Before anything happened, please make sure that you have rights to use Rosetta.**

## Branches

Rosetta image tags correspond to the official [Release Notes](https://www.rosettacommons.org/docs/latest/release-notes).

## Setup

1. Get Rosetta2Go
    ```bash
    git clone https://github.com/Metaphorme/Rosetta2Go.git
    ```

2. Checkout into the branch correspond to the version of Rosetta you have
    ```bash
    cd Rosetta2Go
    git checkout 3.13
    ```

3. Move Rosetta 3.13 source into Rosetta2Go directory
    ```bash
    Rosetta2Go
    ├── build4singularity.sh
    ├── Dockerfile
    ├── LICENSE
    ├── README.md
    ├── rosetta_src_3.13_bundle.tgz
    └── Singularity.def
    ```

## Build for Docker (If you need)

**Python3 required**, or other fileserver, like caddy.

```bash
chmod +x build4docker.sh
./build4docker.sh
```

## Build for Singularity (If you need)

**Python3 required**, or other fileserver, like caddy.

```bash
chmod +x build4singularity.sh
./build4singularity.sh
```

## Usage

Rosetta is located in `/rosetta`.

### Run on Docker

```bash
# This command will mount $HOME/data to /data
docker run -it -v $HOME/data:/data rosetta
score_jd2.mpi.linuxgccrelease -in:file:s /data/3tdm.pdb

# Run with MPI
mpirun -n <NUMBER_OF_RANKS> docker run -it -v $HOME/data:/data rosetta
```

### Run on Singularity
Singularity will automatically mount $HOME, /tmp, /proc, /sys.

```bash
singularity shell rosetta.sif
score_jd2.mpi.linuxgccrelease -in:file:s /data/3tdm.pdb

# Run with MPI
mpirun -n <NUMBER_OF_RANKS> singularity shell rosetta.sif
```

Or:

```bash
# Run on Docker
docker run -v $PWD:/data -i rosetta score_jd2.mpi.linuxgccrelease -in:file:s /data/3tdm.pdb
# Run on Docker with MPI
mpirun -n <NUMBER_OF_RANKS> docker run -v $PWD:/data -i rosetta score_jd2.mpi.linuxgccrelease -in:file:s /data/3tdm.pdb

# Run on Singularity
singularity exec rosetta.sif score_jd2.mpi.linuxgccrelease -in:file:s /data/3tdm.pdb
# Run on Singularity with MPI
mpirun -n <NUMBER_OF_RANKS> singularity exec rosetta.sif score_jd2.mpi.linuxgccrelease -in:file:s /data/3tdm.pdb
```

## Build on Github Actions

If you don't want to build locally, you could also build on Github Actions. Just do it as follows!

1. Fork this repository.

2. Set the password to download Rosetta:
- Switch into your repository.
- Settings -> Security -> Secrets -> Actions -> New repository secret
- Set Name as `PASSWORD`, set secret as your password (the username seems always `Academic_User`, so we don't need to care about it).

3. Enable Actions, choose the workflow which you need to build.

4. Click `Run workflow`, set `Upload image to GoFile` to `true`.

5. Run workflow.

6. Have lunch and go to sleep...

7. After the workflow run successfully, check `Sunmmy` -> `Annotations` to find the download link.

## FAQ

Q: Why don't you build images and release (e.g. Github/Docker Hub)?

A: Because of the [LICENSE of Rosetta](https://www.rosettacommons.org/software/license-and-download), I have no right to publish the images to everyone.

Q: Why we need a fileserver while building images? Why not multi-stage builds? Will it be unsafe?

A: We could use `COPY` or `ADD` on Docker and Singularity, but they will create a huge layer to store the useless package and never delete [Click this for more info](https://docs.docker.com/storage/storagedriver/#images-and-layers). Multi-stage builds is actually a good idea, it could result in a smaller image, but leave a huge dangling image on building computer, which is a waste although you could delete them manually, but result in the troubles to build on the less storage computer, like Github Actions. The fileserver is only expose fileserver to localhost, it will only share the `Rosetta2Go` directory, and it will be shutdown after building is finished.

Q: Why we need to download Rosetta package before building images while building locally? Why don't we download the package while building images?

A: It is not always easy for people living in some countries to download Rosetta successfully at one time.

Q: Once I run `score_jd2.default.linuxgccrelease` and it turns out 'command not found', what should I do?

A: With MPI supported, the applications are named like `score_jd2.mpi.linuxgccrelease`. Check `/rosetta/source/bin` to find the list of applications.

Q: How to import Docker images build on Github Actions?

A: Download `rosetta-3.13.tar.xz`, Run `docker load -i rosetta-3.13.tar.xz`

## Credits

- [Rosetta](https://www.rosettacommons.org/)

- [Microsoft Azure](https://azure.microsoft.com/zh-cn/)

- [Github Actions](https://github.com/features/actions/)

- [Docker](https://www.docker.com/)

- [Singularity](https://sylabs.io/)

- [Alpine](https://www.alpinelinux.org/)

- [Mikubill/transfer](https://github.com/Mikubill/transfer)

- [GoFile](https://gofile.io/)

## Contribute

Contributions welcome! Please open an issue to discuess at first, fork this repository and submit a pull request.

## Thanks

I do appreciate to **every** contributor's warm heart and kindness, especially the sincere advice and hard contributions from [Christopher](https://github.com/CondaPereira), we finished this project together!

## License

[License of Rosetta](https://www.rosettacommons.org/software/license-and-download)

[License of Rosetta2Go](https://metaphorme.github.io/Rosetta2Go/LICENSE):

```
MIT License

Copyright (c) 2022 Metaphorme

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
