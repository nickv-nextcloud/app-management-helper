#!/bin/bash
#

mkdir Branched
cd Branched/
for REPOSITORY in activity \
                  app_api \
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
                  twofactor_nextcloud_notification \
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
                  files_lock \
                  files_retention \
                  flow_notifications \
                  groupfolders \
                  impersonate \
                  ldap_contacts_backend \
                  ldap_write_support \
                  profiler \
                  richdocuments \
                  sharepoint \
                  spreed \
                  user_migration \
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
                  hmr_enabler \
                  mail \
                  notify_push \
                  officeonline \
                  preferred_providers \
                  quota_warning \
                  recognize \
                  tables \
                  talk_matterbridge \
                  terms_of_service \
                  twofactor_webauthn \
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
for REPOSITORY in files_confidential \
                  files_lock \
                  files_downloadlimit \
                  globalsiteselector \
                  security_guard \
                  user_saml
do
    URL="git@github.com:nextcloud/$REPOSITORY.git"
    if [[ "$REPOSITORY" = "security_guard" ]]; then
        URL="git@github.com:nextcloud-gmbh/$REPOSITORY.git"
    fi

    git clone $URL
done
cd ../
