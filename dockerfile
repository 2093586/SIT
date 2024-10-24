# Use Windows Server Core image
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Set environment variables for the runner
ENV RUNNER_VERSION=2.307.0
ENV RUNNER_NAME=sourabh
ENV RUNNER_TOKEN=BL2IIEOUP77MKMGJBJPSZEDHDJWKW
ENV RUNNER_REPOSITORY=https://github.com/2093586/TR
ENV RUNNER_WORKDIR=C:\actions-runner
# Create working directory
RUN mkdir .\actions-runner
# Download the GitHub Actions runner package
RUN powershell -Command \
    Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-win-x64-2.320.0.zip -OutFile runner.zip; \
    Expand-Archive -Path runner.zip -DestinationPath .; \
    Remove-Item -Force runner.zip

# Configure the GitHub Actions runner
RUN .\config.cmd --url https://github.com/${RUNNER_REPOSITORY} --token ${RUNNER_TOKEN}

# Start the GitHub Actions runner
CMD ["cmd", "/c", ".\\run.cmd"]
