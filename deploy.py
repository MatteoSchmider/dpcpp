import argparse
import os
import pathlib
import sys


def run(cmd: str) -> int:
    if os.system(cmd) != 0:
        sys.exit(1)


def main() -> int:
    parser = argparse.ArgumentParser(description='deploy the dpc++ compiler for various platform and backend combinations')
    parser.add_argument('--platform',
                        nargs=1,
                        default='ubuntu',
                        type=str,
                        choices=['ubuntu', 'win'],
                        required=True,
                        help='specify which platform to deploy for')
    parser.add_argument('--backend',
                        nargs=1,
                        default='opencl',
                        type=str,
                        choices=['cuda', 'hip-amd', 'hip-nvidia', 'opencl'],
                        required=True,
                        help='specify which backend to deploy for')
    parser.parse_args(sys.argv)

    script_name = parser.backend + '.sh'

    if parser.platform == 'win':
        script_name = parser.backend + '.ps1'
        if parser.backend in ['hip-amd', 'hip-nvidia']:
            print('Windows only supports the backends [cuda, opencl]!')
            return 1
        if os.name != 'nt':
            print('deploying for windows is only supported on a windows host system!')
            return 1

    base_path = pathlib.Path(__file__)
    script_path = base_path / 'deploy' / parser.platform
    output_path = base_path / 'dpcpp'
    output_path.mkdir()

    cmd = 'docker run --rm --memory 12g '
    cmd += '-v ' + str(output_path.resolve()) + ':"C:\llvm '
    cmd += '-v ' + str(script_path.resolve()) + ':"C:\ '
    cmd += 'mcr.microsoft.com/windows/servercore:ltsc2022 powershell -command "C:\\' + script_name + '"'

    if os.system(cmd) != 0:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
