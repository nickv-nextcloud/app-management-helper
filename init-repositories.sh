#!/bin/bash
#

mkdir Branched
cd Branched/
for REPOSITORY in activity \
                  bruteforcesettings \
                  circles \
                  files_pdfviewer \
                  files_rightclick \
                  files_videoplayer \
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
for REPOSITORY in backup \
                  data_request \
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
                  groupfolders \
                  impersonate \
                  ldap_contacts_backend \
                  ldap_write_support \
                  profiler \
                  richdocuments \
                  sharepoint \
                  spreed \
                  terms_of_service \
                  user_migration \
                  user_retention \
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
                  calendar \
                  contacts \
                  files_antivirus \
                  files_downloadactivity \
                  files_downloadlimit \
                  files_texteditor \
                  files_zip \
                  forms \
                  globalsiteselector \
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
                  ransomware_protection \
                  recognize \
                  registration \
                  social \
                  talk_matterbridge \
                  twofactor_u2f \
                  twofactor_webauthn \
                  user_oidc \
                  user_saml
do
    URL="git@github.com:nextcloud/$REPOSITORY.git"

    git clone $URL
done
cd ../
