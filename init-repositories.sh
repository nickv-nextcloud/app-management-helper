#!/bin/bash
#

mkdir Branched
cd Branched/
for REPOSITORY in activity \
                  bruteforcesettings \
                  circles \
                  files_pdfviewer \
                  firstrunwizard \
                  logreader \
                  nextcloud_announcements \
                  notifications \
                  password_policy \
                  photos \
                  privacy \
                  recommendations \
                  related_resources \
                  serverinfo \
                  support \
                  survey_client \
                  suspicious_login \
                  text \
                  twofactor_totp \
                  viewer
do
    URL="git@github.com:nextcloud/$REPOSITORY.git"
    if [[ "$REPOSITORY" = "support" ]]; then
        URL="git@github.com:nextcloud-gmbh/$REPOSITORY.git"
    fi

    git clone $URL
done
cd ../

mkdir Stable
cd Stable/
for REPOSITORY in data_request \
                  deck \
                  end_to_end_encryption \
                  external \
                  files_accesscontrol \
                  files_automatedtagging \
                  files_fulltextsearch \
                  files_retention \
                  flow_notifications \
                  fulltextsearch \
                  fulltextsearch_elasticsearch \
                  globalsiteselector \
                  groupfolders \
                  impersonate \
                  ldap_contacts_backend \
                  ldap_write_support \
                  profiler \
                  richdocuments \
                  sharepoint \
                  spreed \
                  user_usage_report \
                  workflow_pdf_converter \
                  workflow_script
do
    URL="git@github.com:nextcloud/$REPOSITORY.git"

    git clone $URL
done
cd ../

mkdir Multibranch
cd Multibranch/
for REPOSITORY in announcementcenter \
                  call_summary_bot \
                  calendar \
                  contacts \
                  files_antivirus \
                  files_confidential \
                  files_downloadlimit \
                  files_zip \
                  guests \
                  integration_discourse \
                  integration_github \
                  integration_gitlab \
                  integration_google \
                  integration_jira \
                  integration_mastodon \
                  integration_moodle \
                  integration_reddit \
                  integration_twitter \
                  integration_whiteboard \
                  integration_zammad \
                  jsloader \
                  mail \
                  notify_push \
                  officeonline \
                  preferred_providers \
                  quota_warning \
                  recognize \
                  registration \
                  social \
                  talk_matterbridge \
                  terms_of_service \
                  translate \
                  twofactor_webauthn \
                  user_migration \
                  user_oidc \
                  user_retention \
                  user_saml
do
    URL="git@github.com:nextcloud/$REPOSITORY.git"


    git clone $URL
done
cd ../

mkdir Enterprise
cd Enterprise/
for REPOSITORY in globalsiteselector \
                  user_saml \
                  files_lock \
                  files_confidential \
                  security_guard
do
    URL="git@github.com:nextcloud/$REPOSITORY.git"
    if [[ "$REPOSITORY" = "security_guard" ]]; then
        URL="git@github.com:nextcloud-gmbh/$REPOSITORY.git"
    fi

    git clone $URL
done
cd ../
