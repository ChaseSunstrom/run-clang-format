import os
import subprocess


def run_clang_format(directory, ignored_paths):
    # Define the file extensions to target
    extensions = ('.c', '.cpp', '.h', '.hpp')
    # Normalize and get absolute paths for the ignored directories
    ignored_paths = [os.path.abspath(os.path.normpath(ignore)) for ignore in ignored_paths]

    # Walk through the directory
    for subdir, dirs, files in os.walk(directory):
        # Normalize and get the absolute path of the current subdir
        abs_subdir = os.path.abspath(os.path.normpath(subdir))

        # Check if the current subdir is in the ignored paths
        if any(abs_subdir.startswith(ignore) for ignore in ignored_paths):
            print(f'Skipping ignored directory {subdir}')
            continue

        for file in files:
            # Check if the file ends with a valid C/C++ extension
            if file.endswith(extensions):
                file_path = os.path.join(subdir, file)
                print(f'Formatting {file_path}')
                # Run clang-format and overwrite the file
                clang_format_path = r"C:\Program Files\LLVM\bin\clang-format"
                subprocess.run([clang_format_path, '-i', file_path])


if __name__ == "__main__":
    # Get the directory from command line arguments or use the current directory
    directory = input("Enter directory to run clang format on (default is CWD): ").strip() or os.getcwd()

    # Get a list of directories to ignore
    ignored_input = input("Enter comma-separated paths to ignore (leave blank for none): ").strip()
    ignored_paths = [path.strip() for path in ignored_input.split(",")] if ignored_input else []

    print("Ignoring directories:", ignored_paths)

    run_clang_format(directory, ignored_paths)
