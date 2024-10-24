# Use Windows Server Core image
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Set environment variables for the runner
ENV RUNNER_VERSION=2.307.0
ENV RUNNER_NAME=sourabh
ENV RUNNER_TOKEN=BL2IIEOUP77MKMGJBJPSZEDHDJWKW
ENV RUNNER_REPOSITORY=https://github.com/2093586/TR
ENV RUNNER_WORKDIR=C:\actions-runner

# Create working directory
RUN mkdir C:\actions-runner

# Set the working directory
WORKDIR C:\actions-runner

# Download the GitHub Actions runner package
RUN powershell -Command \
    Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v%RUNNER_VERSION%/actions-runner-win-x64-%RUNNER_VERSION%.zip -OutFile runner.zip; \
    Expand-Archive -Path runner.zip -DestinationPath .; \
    Remove-Item -Force runner.zip

# Install required dependencies (e.g., Git)
RUN powershell -Command \
    Invoke-WebRequest -Uri https://github.com/git-for-windows/git/releases/latest/download/PortableGit-x64.7z.exe -OutFile git.7z; \
    7z x git.7z -oC:\git; \
    Remove-Item -Force git.7z

# Add Git to the PATH
ENV PATH="C:\git\cmd;${PATH}"

# Configure the GitHub Actions runner
RUN .\config.cmd --url https://github.com/${RUNNER_REPOSITORY} --token ${RUNNER_TOKEN}

# Start the GitHub Actions runner
CMD ["cmd", "/c", ".\\run.cmd"]
