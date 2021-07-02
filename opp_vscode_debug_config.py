import json
import argparse
import pathlib

# GDB Config for Microsoft C/C++ Plugin


class GdbConfig:
    def __init__(self, omnetpp, target, rundbg, args, cwd, debugger, setup_commands):
        self.model = {
            "name": "Launch {} - GDB (OMNeT++)".format(target),
            "type": "cppdbg",
            "request": "launch",
            "program": rundbg,
            "args": args,
            "stopAtEntry": False,
            "cwd": cwd,
            "externalConsole": False,
            "MIMode": "gdb",
            "miDebuggerPath": debugger,
            "setupCommands": setup_commands
        }

    @property
    def name(self):
        return self.model['name']


# Config for CodeLLDB Extension
class CodeLldbConfig:
    def __init__(self, omnetpp, target, rundbg, args, cwd, debugger, setup_commands):
        self.model = {
            "name": "Launch {} - CodeLLDB (OMNeT++)".format(target),
            "type": "lldb",
            "request": "launch",
            "program": rundbg,
            "args": args,
            "stopOnEntry": False,
            "cwd": cwd,
            "initCommands": [
                "command script import {}/python/omnetpp/lldb/formatters/omnetpp.py".format(
                    omnetpp)
            ]
        }

    @property
    def name(self):
        return self.model['name']


def main():
    # Reassemble OPP-Run-DBG CLI
    parser = argparse.ArgumentParser(
        description='Add OMNeT++ debug configuration to VS-Code (to be done called by CMake-OMNet++ package).')
    parser.add_argument(
        'config', type=str, help='Config to export. Valid values are GDB and CodeLLDB.')
    parser.add_argument('target', type=str, help='The target to debug')
    parser.add_argument('root', type=str,
                        help='Workspace root-folder (containing .vscode folder).')
    parser.add_argument('omnetpp', type=str, help="OMNeT++ root folder.")
    parser.add_argument('working_directory', type=str, help="working directory of debug target.")
    parser.add_argument('debugger', type=str,
                        help='Path to debugger.')
    parser.add_argument('rundbg', type=str,
                        help='The OMNeT++ executable (opp_run_dbg).')
    parser.add_argument('-n', type=str,
                        help='NED Folders to be added to opp_run_dbg call.')
    parser.add_argument('-l', type=str, action='append',
                        help='Libraries to be added as argument to the opp_run_dbg call.')
    parser.add_argument('inifile', type=str,
                        help="Path to OMNeT++ ini-file")
    args = parser.parse_args()

    # Path to launch.json file
    launch_file = args.root / pathlib.Path('.vscode/launch.json')
    if not launch_file.is_file():
        print("Failed to add VS-Code debug config for {} - this script only appends to an existing file.".format(args.target))
        return

    # Load additional commands for the debugger if omnetpp-debug-setup-commands.json file exists
    setup_commands_file = args.root / \
        pathlib.Path('.vscode/omnetpp-debug-setup-commands.json')
    setup_commands = []
    if setup_commands_file.is_file():
        try:
            with setup_commands_file.open() as f:
                setup_commands = json.load(f)
        except ValueError as e:
            print('Invalid setup commands in file: {}'.format(e))

    # Match to launch.json arguments
    launch_args = []
    launch_args.append('-n')
    launch_args.append(args.n)

    for l in args.l:
        launch_args.append('-l')
        launch_args.append(l)

    launch_args.append(args.inifile)

    # Create the debug-config for the given target using launch.json model
    switcher = {
        "GDB": GdbConfig(args.omnetpp, args.target, args.rundbg, launch_args, args.working_directory, args.debugger, setup_commands),
        "CodeLLDB": CodeLldbConfig(args.omnetpp, args.target, args.rundbg, launch_args, args.working_directory, args.debugger, setup_commands)
    }

    config = switcher[args.config]

    with launch_file.open("a+") as f:
        try:
            f.seek(0)
            launch_settings = json.load(f)

            # create empty configurations list if missing
            if not 'configurations' in launch_settings:
                launch_settings['configurations'] = []

            # Remove any existing config with same name
            for index, item in enumerate(launch_settings['configurations']):
                if item['name'] == config.name:
                    launch_settings['configurations'].pop(index)
                    break

            # Insert config into list of configs
            launch_settings['configurations'].append(config.model)

            # Serialize to file
            f.seek(0)
            f.truncate()
            json.dump(launch_settings, f, indent=4)

            print(
                "Sucessfully added debug-configuration to launch.json for {}".format(args.target))

        except ValueError as e:
            print("""Invalid JSON-File given: {}. Make sure that launch.json 
                     does not contain comments and is strictly complying to json standards!""".format(e))


if __name__ == "__main__":
    main()
