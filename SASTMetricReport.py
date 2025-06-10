#!/usr/bin/python3

###################################################################################################
#
#                               Lockheed Martin Proprietary Information
#
#                              Copyright 2024 Lockheed Martin Corporation
#                             as an unpublished work. All rights reserved.
#
###################################################################################################
#                                       Current Version - 1.10.2
###################################################################################################
#
#                               Versioning Key: Major.Minor.Patch.Build
#
# Major: Large changes to the code base that affect how the script operates. This type of change
#        may also affect how the user/customer interacts with the program.
#
# Minor: Changes to the code base that add to, or remove from, the functionality of the script,
#        without changing how the user interacts with the code.
#
# Patch: Bug fixes that, ultimately, leave the program in a fairly untouched state.
#
# Build: The hotfix, or build, identifier. This is used to track the incredibly minor changes
#        that do not justify a patch increment.
#
###################################################################################################
#  Change                               Author                  Version                  Date
#
#  Fixed a duplication bug in the
#  name generation for CSV files
#  output for CPPCheck reports.
#  Additionally, an error log is
#  now generated, regardless of
#  crash conditions.                    Kobie McDuffee          1.10.2                   04/10/2025
#
#  Fixed a bug that caused a branch
#  comparison routine to compare
#  against itself. This will always
#  result in a blank report. With
#  this patch, this behavior should
#  be corrected.                        Kobie McDuffee          1.10.1                   03/27/2025
#
#  Added SWR report generation.         Stuart Bridge           1.10.0                   01/30/2025
#
#  Updated the SASTMetricReport.py
#  driver script to migrate SCA
#  processing and digest functions
#  to the new scadgst.py module.
#  This has been done to clean
#  up the driver script for better
#  readability. This also provides
#  a dedicated module for authoring
#  SCA processing utilities.            Kobie McDuffee          1.9.0                    11/07/2024
#
#  Updated the sscinfc.py module
#  to add an initializer to the
#  previousScanDate variable of
#  the RetrieveArtifactData
#  function. Previously, this was
#  causing a crash under specific
#  circumstances.                       Kobie McDuffee          1.8.7                    12/12/2024
#
#  Updated the sscinfc.py module
#  to add support for sorting issue
#  data and removing suppressed
#  issues.                              Kobie McDuffee          1.8.6                    12/11/2024
#
#  Updated the codebase to provide
#  reference branch dates to the
#  generated SMRT Report.               Kobie McDuffee          1.8.5                    10/29/2024
#
#  Updated cmdargs.py to allow an
#  empty string to be passed to
#  -m. Updated csvwrit.py to
#  correctly parse an empty string
#  when authoring the Reference
#  Scan field. Updated helpers.py
#  to add -m/--MainBranch to the
#  Help Menu.                           Kobie McDuffee          1.8.4                    10/24/2024
#
#  Updated cmdargs.py to support
#  the new -m and --MainBranch
#  command line arguments. Also,
#  the SASTMetricReport.py script
#  has been updated to better
#  format the module-level
#  attributes (dunders).                Kobie McDuffee          1.8.4                    10/15/2024
#
#  Updated the csvwrit.py module
#  to remove unused sections when
#  not using the LatestIssues.          Kobie McDuffee          1.8.4                    10/10/2024
#
#  Updated the logic for the
#  file filter. Previously,
#  entries had to have their
#  directories stripped. Now,
#  files can be passed in with
#  their "relative"
#  directories.                         Kobie McDuffee          1.8.3                    08/14/2024
#
#  Corrected a return zero
#  in the
#  CPPCheckDataFromDirectory
#  function. Now, an error
#  raises status one. Also,
#  added a new command line
#  argument that prints the
#  version data to the screen.          Kobie McDuffee          1.8.2.1                  08/14/2024
#
#  Fixed a bug in catfilt.py
#  that resulted in categories
#  not being located when the
#  capability was run outside
#  its home directory.                  Kobie McDuffee          1.8.2                    08/05/2024
#
#  Updated the codebase to
#  correct an error where
#  the Fortify SSC was being
#  pulled from, even when
#  users were only processing
#  CPPCheck data.                       Kobie McDuffee          1.8.1                    08/04/2024
#
#  Update the codebase to use
#  the new Category Filter
#  subsystem. This new system
#  uses *-ruleset-map.json
#  files to define categories.
#  Additionally, the codebase
#  was further modularized.             Kobie McDuffee          1.8.0                    07/31/2024
#
#  Updated the backend code
#  for the way CSV files are
#  generated. Future updates
#  made to accommodate other
#  SCAs should be simpler due
#  to these changes. The user
#  experience is not affected
#  by this update.                      Kobie McDuffee          1.7.1                    07/03/2024
#
#  Updated the script to remove
#  the ParseArgs function and
#  migrate it to the cmdargs
#  module. Additionally, the
#  CreateAndWriteCSV function
#  has been split up into
#  several functions to aid in
#  accomodating XML parsing
#  from CPPCheck.                       Kobie McDuffee          1.7.0                    06/10/2024
#
#  Updated the script to
#  migrate Project INIT
#  functions to their own class
#  and module.                          Kobie McDuffee          1.6.1                    05/30/2024
#
#  Updated the script to split
#  its functionality into
#  modules. These modules are
#  currently stored in the
#  modules subdirectory.                Kobie McDuffee          1.6.0                    05/25/2024
#
#  Added new Scan Status column
#  to the report CSV output.            Kobie McDuffee          1.5.5                    05/21/2024
#
#  Updated the createAndWriteCSV
#  function to now use
#  "issueInstanceId" instead of
#  "id" for the CID value.              Kobie McDuffee          1.5.4                    05/20/2024
#
#  Removed old conditional check
#  for handling user filters.
#  The new implementation takes
#  up less lines, operates on a
#  simple True-False bool, and
#  allows for simpler processing
#  of the check. With this, the
#  currently supported user
#  filters should properly
#  impact the output of the
#  generated report.                    Kobie McDuffee          1.5.3                    04/24/2024
#
#  Added new function to separate
#  parsing command line arguments
#  into a different function than
#  main. This should provide a
#  cleaner execution flow for
#  maintainers.                         Kobie McDuffee          1.5.2                    04/24/2024
#
#  Fixed the new defect count
#  when latest filter is not applied,
#  to also count new defects            Nutthinee Marchlik      1.5.1                    04/10/2024
#
#  Removed multiple
#  global scoped
#  variables to reduce
#  chances for conflicts
#  in code. A step towards
#  this goal was migrating
#  the starting logic to
#  its own main function.
#  In theory, not using
#  global variables
#  should lower the risk
#  of unintentionally
#  overwriting data in
#  a function that used
#  used the same variable
#  name as global.                      Kobie McDuffee          1.5.0                    03/28/2024
#
#  Added a conditional
#  check for scanStatus of
#  New for finding latest
#  data found the first
#  time by Fortify SCA                  Nutthinee Marchlik      1.4.0                    03/25/2024
#
#  Implemented additional
#  functions to help
#  identify conditions on
#  which to filter issues
#  in loops.                            Kobie McDuffee          1.3.0                    03/20/2024
#
#  Updated handling -c &
#  -f command line args.                Kobie McDuffee          1.2.0                    03/11/2024
#
#  Adding Change control
#  and versioning                       Nutthinee Marchlik      1.1.1                    02/22/2024
#
#  CSlAGILE-8362,
#  ETS-8354                             Kobie McDuffee          1.1.0                    02/21/2024
#
#  Suppressed certificate
#  warnings caused by
#  HTTP GET requests. Also,
#  patched the UTC stamp.               Kobie McDuffee          1.0.1                    01/19/2024
#
#  Initial                              Lee, Steven             1.0.0                    10/30/2023
###################################################################################################

# Module-Level Dunders
__all__ = [
    "Main"
]

__version__ = "1.10.2"

__author__ = "McDuffee, Kobie R (US); Marchlik, Nutthinee (US); Bridge, Stuart W (US)"

# Module-Level Imports
from traceback import format_exc

from modules.apiwrap import APIWrapper
from modules.catfilt import GetCategoryFilter
from modules.cmdargs import ParseArgs
from modules.helpers import ClearScreen, PrintHelp, WriteLog, WriteLogFile, CreateLogString
from modules.scadgst import ProcessSSCData, ProcessCPPCheck
from modules.prjinit import ProjectInitWrap

import datetime
import getopt
import os
import sys

def Main() -> None:
    """ Driver function for the capability.
    """

    headers = {
        "Content-Type": "application/json",
        "Accept": "application/json"
    }

    ClearScreen()

    with open("SMRT_ERROR_LOG.txt", 'w') as file:
        file.write("")

    message = f"SAST Metric Report Tool v{__version__} Initializing..."

    WriteLog(message, 0, False, -1)

    if len(sys.argv) == 1:
        message = "This program requires arguments.\r\nPlease examine " + \
                  "the help menu below:"
        
        logString = CreateLogString(message, 3)

        PrintHelp(logString, True)

    try:
        commandLineArguments = ParseArgs(__version__)
    except getopt.error as e:
        message = str(e)

        logString = CreateLogString(message, 3)

        PrintHelp(logString, True)

    projectName = commandLineArguments.GetProjectName()

    versionName = commandLineArguments.GetVersionName()

    latestIssues = commandLineArguments.GetLatestIssues()

    cppcheckPath = commandLineArguments.GetCPPCheck()

    cppcheckDefects = commandLineArguments.GetCPPCheckDefect()

    categories = commandLineArguments.GetCategoryFilter()

    fileFilter = commandLineArguments.GetFileFilter()

    fileFilterFromFile = commandLineArguments.GetFileFilterFromFile()

    sscToken = commandLineArguments.GetToken()

    asapToken = commandLineArguments.GetASAPToken()

    repoURL = commandLineArguments.GetRepoURL()

    jobId = commandLineArguments.GetJobID()

    netId = commandLineArguments.GetNetID()

    sscURL = commandLineArguments.GetSSCURL()

    asapURL = commandLineArguments.GetASAPURL()

    mainBranch = commandLineArguments.GetMainBranch()

    branchCompare = commandLineArguments.GetBranchComparison()

    writeSWR = commandLineArguments.GetWriteSWR()

    # Get Category Ruleset
    categoryFilter = GetCategoryFilter(categories)

    # Combine the File Filter and File Filter From File
    for entry in fileFilterFromFile:
        if entry not in fileFilter:
            fileFilter.append(entry)

    try:
        print("Checking Requirements for SSC Data Pulling...")

        if sscURL != None:
            try:
                sscWrap = APIWrapper(sscURL)

                asapWrap = APIWrapper(asapURL)

                projectInit = ProjectInitWrap(asapWrap,
                                              asapToken,
                                              netId,
                                              repoURL,
                                              projectName,
                                              versionName,
                                              jobId)

                if sscToken == None:
                    _, sscToken = projectInit.ObtainEnterpriseServicesCred()

                headers.update((("Authorization",
                                 f"FortifyToken {sscToken}"),))

                print("SSC Data Pull Requirements Met! Proceeding...")

                ProcessSSCData(sscWrap,
                               projectInit,
                               sscToken,
                               fileFilter,
                               categoryFilter,
                               latestIssues,
                               mainBranch,
                               branchCompare,
                               headers,
                               writeSWR)
            except Exception as e:
                message = "An error was encountered while " + \
                          "trying to generate a Fortify SSC data " + \
                          f"report!\r\nReason: {e}"

                trace = format_exc()

                WriteLogFile(__version__, __author__, trace)

                WriteLog(message, 2, True, 4)
        else:
            message = "Fortify SSC URL not supplied! " + \
                      "SSC data will not be pulled!"

            print(message)

        if cppcheckPath != None:
            try:
                ProcessCPPCheck(categoryFilter,
                                cppcheckDefects,
                                cppcheckPath,
                                fileFilter,
                                latestIssues,
                                mainBranch,
                                versionName)
            except Exception as e:
                message = "An error was encountered while " + \
                          "trying to generate a CPPCheck data report!" + \
                          f"\r\nReason: {e}"

                trace = format_exc()

                WriteLogFile(__version__, __author__, trace)

                WriteLog(message, 2, True, 5)
        else:
            message = "CPPCheck location not provided! " + \
                      "CPPCheck data will not be processed!"

            print(message)

        message = "SAST Metric Report Tool Completed with Zero (0) Errors!"

        WriteLogFile(__version__, __author__, None)

        WriteLog(message, 0, True, 0)

    except Exception as e:
        # Output an error message and return with an exit code.
        message = "SAST Metric Report Tool has Encountered an Error!" + \
                  "\n\rPlease check most recent crash log."

        trace = format_exc()

        WriteLogFile(__version__, __author__, trace)

        WriteLog(message, 4, True, 1)
    finally:
        if os.path.exists("SMRT_ERROR_LOG.txt"):
            currentTime = datetime.datetime.now()

            logTime = currentTime.strftime("%Y-%m-%d-%H:%M:%S")

            os.rename("SMRT_ERROR_LOG.txt", f"SMRT_ERROR_LOG-{logTime}.txt")

if __name__ == "__main__":
    Main()
