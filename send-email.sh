#!/bin/bash
# Simple script to send email

missing_arg() {
  [[ -z $1 ]];
}

usage() {
  echo "Usage:"
  echo "  -h, --help:      Display this help message"
  echo "  -t, --to:        Specify the To field"
  echo "  -s, --subject:   Specify the Subject field"
  echo "  -b, --body:      Specify the Body field"
  echo ""
  echo "This script expects ssmtp to be installed and for the /etc/ssmtp/ssmtp.conf file to be configured properly. Example:"
  echo "  root=youremail@example.com"
  echo "  mailhub=smtp.example.com:465"
  echo "  rewriteDomain=example.com"
  echo "  AuthUser=username"
  echo "  AuthPass=password"
  echo "  FromLineOverride=YES"
  echo "  UseTLS=YES"
}

if [[ $# -eq 0 ]]; then
  echo "No arguments provided."
  echo ""
  usage
  exit
fi

while [[ $# -gt 0 ]]; do
  case $1 in
    -h | --help) # Help message
      usage && exit
      ;;
    -t | --to) # Set the email's To field
      email_to=$2
      shift
      ;;
    -s | --subject) # Set the email's Subject field
      email_subject=$2
      shift
      ;;
    -b | --body) # Set the email's Body field
      email_body=$2
      shift
      ;;
    *)
      # Handle invalid options
      echo "Invalid arguments provided." && exit
      ;;
  esac
  shift
done

should_exit=false

if [[ -z $email_to ]]; then
  echo "Missing To field." && should_exit=true
fi
if [[ -z $email_subject ]]; then
  echo "Missing Subject field." && should_exit=true
fi
if [[ -z $email_body ]]; then
  echo "Missing Body field." && should_exit=true
fi

if [[ $should_exit = true ]]; then
  exit
fi

echo "Sending email..."
printf "To: %s\nSubject: %s\n\n%s" "$email_to" "$email_subject" "$email_body" | ssmtp -v $email_to
