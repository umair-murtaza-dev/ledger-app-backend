class Mocking::Service
  def initialize(admin=false)
    @admin = admin
  end

  def normal_account_data
    {
      "id": "096dbece-f82e-11e8-809b-0252151e4411",
      "provisioningId": 2,
      "chargingId": 2,
      "crmId": "160818142823",
      "name": "Morni KSA",
      "balance": 76.5443,
      "country": "Saudi Arabia",
      "accountManagerName": "",
      "accountManagerEmail": "",
      "type": nil,
      "category": nil,
      "twoFactorAuthenticationEnabled": false
    }
  end

  def normal_user
    {
      "id": "9aec00f8-c127-4481-bc2f-5e6f721c12e3",
      "email": "dev@morniksa.com",
      "firstName": "Morni",
      "lastName": "KSAAA",
      "phone": "+966555789465",
      "roles": normal_roles,
      "permissions": normal_permissions,
      "timezone": "Asia/Riyadh",
      "isAdminLevel": false,
      "defaultCurrency": "USD"
    }
  end

  def normal_permissions
    {
      "CC": {
        "TRAFFIC_REPORT": ["SEE_OWN"],
        "DOCUMENTATION_LINK": ["SEE"],
        "SENDER_NAME": ["SEE_OWN", "DEACTIVATE_OWN", "CREATE_OWN", "DELETE_OWN", "EDIT_OWN"],
        "APPS_ID": ["EDIT_OWN", "DELETE_OWN", "CREATE", "SEE_OWN"],
        "SENDER_NAME_AUTO_APPROVE": ["APPROVE_OWN"],
        "DECRYPTED_MESSAGE_CONTENT": ["DECRYPT_OWN"],
        "CONSUMPTION_REPORT": ["SEE_OWN"],
        "MESSAGE_LOG": ["SEE_OWN"],
        "APPLICATION_SMPP_BIND_TYPE": ["EDIT"]
      },
      "UC": {
        "USER_PROFILE": ["SEE_OWN", "EDIT_OWN"],
        "ACCOUNT": ["SEE_OWN"],
        "SUB_ACCOUNT": ["CREATE", "EDIT_OWN", "SEE_OWN"],
        "BALANCE": ["SEE_OWN", "TRANSFER"],
        "USER": ["CREATE", "EDIT_OWN", "SEE_OWN"],
        "PAYMENT": ["SEE_OWN"],
        "PACKAGE": ["TRANSFER", "SEE_OWN"],
        "TOP_UP": ["PAY"],
        "TRANSFER_LOG": ["EXPORT_OWN"],
        "TWO_FA": ["EDIT_OWN"],
        "IMPERSONATE": ["SEE_OWN"]
      },
      "CONV": {
        "SLACK_FOR_SUPPORT": ["SEE_OWN", "CREATE"],
        "BOT_BUILDER": ["CREATE", "SEE_OWN"],
        "CUSTOMER": ["CREATE", "SEE_OWN"],
        "APPLICATION": ["SEE_OWN", "CREATE"]
      },
      "NT": {
        "APP": ["CREATE_OWN", "DELETE_OWN", "SEE_OWN", "EDIT_OWN"],
        "CREDENTIAL": ["DELETE_OWN", "SEE_OWN", "EDIT_OWN", "CREATE_OWN"],
        "NOTIFICATION": ["SEE_OWN"],
        "NOTIFICATION_LOG": ["SEE_OWN"]
      },
      "MP": {
        "APPLICATION": ["EDIT_OWN", "SEE_OWN"]
      }
    }
  end

  def normal_roles
    ["ACCOUNT_USER", "ACCOUNT_ADMIN"]
  end

  def admin_user
    {
      "id": "f16dd21e-a5f1-4031-95e4-632dff5bac4a",
      "email": "aalhusainy@unifonic.com",
      "firstName": "Ahmad",
      "lastName": "Al Husainy",
      "phone": "+962785295462",
      "roles": admin_roles,
      "permissions": admin_permissions,
      "timezone": "Asia/Riyadh",
      "isAdminLevel": true,
      "defaultCurrency": "USD"
    }
  end

  def admin_roles
    ["ADMIN", "SUPPORT"]
  end

  def admin_permissions
    {
    	"UC": {
    		"APPROVAL_REQUEST": ["REJECT", "APPROVE", "SEE_ALL"],
    		"USER": ["SUPER_EDIT", "EDIT_ALL", "CREATE", "SUPER_SEE", "SEE_ALL", "SUPER_CREATE"],
    		"BALANCE": ["DEDUCT", "TOP_UP", "SEE_ALL"],
    		"PAYMENT": ["SEE_ALL"],
    		"PACKAGE": ["DEACTIVATE_ALL", "TOP_UP", "ACTIVATE_ALL", "SEE_ALL", "DEDUCT"],
    		"USER_PROFILE": ["SEE_OWN", "EDIT_OWN"],
    		"ACCOUNT": ["SEE_ALL", "CREATE", "EDIT_ALL"],
    		"LEGACY_IMPERSONATE": ["SEE_ALL"],
    		"PRICE_RATE": ["SEE_ALL", "EDIT_ALL"],
    		"IMPERSONATE": ["SEE_ALL"],
    		"TWO_FA": ["EDIT_ALL"]
    	},
    	"CC": {
    		"SENDER_NAME": ["CREATE_ALL", "APPROVE", "DEACTIVATE_ALL", "ACTIVATE_ALL", "SEE_ALL"],
    		"APPS_VOICE": ["SEE_ALL", "EDIT_ALL"],
    		"CAMPAIGN": ["SEE_ALL", "DELETE_ALL"],
    		"APPS_ID": ["SMPP_SEE_ALL", "SMPP_EDIT_ALL"],
    		"CONSUMPTION_REPORT": ["SEE_ALL"],
    		"MASKED_CALL_LOGS": ["SEE_ALL"],
    		"TRAFFIC_REPORT": ["SEE_ALL"],
    		"DOCUMENTATION_LINK": ["SEE"],
    		"APPLICATION_SMPP_BIND_TYPE": ["EDIT"],
    		"FACEBOOK_APP": ["SEE_ALL"],
    		"CALLER": ["SEE_ALL"],
    		"ROUTING_RULES": ["ALL"],
    		"MESSAGE_LOG": ["SEE_ALL"]
    	},
    	"NT": {
    		"NOTIFICATION": ["SEE_ALL"],
    		"APP": ["DELETE_ALL", "CREATE_ALL", "EDIT_ALL", "SEE_ALL"],
    		"NOTIFICATION_LOG": ["SEE_ALL"]
    	},
    	"CONV": {
    		"APPLICATION": ["SEE_ALL"]
    	}
    }
  end

  def current_user
    user = (@admin ? admin_user : normal_user).with_indifferent_access
    account = @admin ? nil : current_account
    UnifonicCloud::Auth::UserDto.new(
      id: user['id'],
      email: user['email'],
      first_name: user['firstName'],
      last_name: user['lastName'],
      name: [user['firstName'], user['lastName']].select(&:present?).join(' '),
      phone: user['phone'],
      roles: user['roles'],
      permissions: user['permissions']&.with_indifferent_access,
      account: account,
      timezone: user['timezone'],
      is_admin_level: user['isAdminLevel'],
      default_currency: user['defaultCurrency'],
      currency: Currencies::CurrencyService.new.fetch_by_key(key: user['defaultCurrency'])
    )
  end

  def current_account
    account_data = normal_account_data.with_indifferent_access
    UnifonicCloud::Auth::AccountDto.new(
      id: account_data['id'],
      provisioning_id: account_data['provisioningId'],
      charging_id: account_data['chargingId'],
      crm_id: account_data['crmId'],
      name: account_data['name'],
      balance: account_data['balance'],
      country: account_data['country'],
      account_manager_name: account_data['accountManagerName'],
      account_manager_email: account_data['accountManagerEmail'],
      type: account_data['type'],
      category: account_data['category'],
      two_factory_authentication_enabled: account_data['twoFactorAuthenticationEnabled']
    )
  end

  def topbar
    @admin ? admin_topbar : normal_topbar
  end

  def admin_topbar
    "<!-- start Segment -->\n<script type=\"text/javascript\">\n  !function(){var analytics=window.analytics=window.analytics||[];if(!analytics.initialize)if(analytics.invoked)window.console&&console.error&&console.error(\"Segment snippet included twice.\");else{analytics.invoked=!0;analytics.methods=[\"trackSubmit\",\"trackClick\",\"trackLink\",\"trackForm\",\"pageview\",\"identify\",\"reset\",\"group\",\"track\",\"ready\",\"alias\",\"debug\",\"page\",\"once\",\"off\",\"on\"];analytics.factory=function(t){return function(){var e=Array.prototype.slice.call(arguments);e.unshift(t);analytics.push(e);return analytics}};for(var t=0;t<analytics.methods.length;t++){var e=analytics.methods[t];analytics[e]=analytics.factory(e)}analytics.load=function(t,e){var n=document.createElement(\"script\");n.type=\"text/javascript\";n.async=!0;n.src=\"https://cdn.segment.com/analytics.js/v1/\"+t+\"/analytics.min.js\";var a=document.getElementsByTagName(\"script\")[0];a.parentNode.insertBefore(n,a);analytics._loadOptions=e};analytics.SNIPPET_VERSION=\"4.1.0\";\n    analytics.load(\"MZTSZupItW5i4M0ipP4VsnfUWzSPrDG6\");\n\n          analytics.page();\n      }}();\n\n  \n    \n    \n    window.analytics.ready(function() {\n        analytics.identify(\"f16dd21e-a5f1-4031-95e4-632dff5bac4a_integration\", {\"id\":\"f16dd21e-a5f1-4031-95e4-632dff5bac4a\",\"email\":\"aalhusainy@unifonic.com\",\"firstName\":\"Ahmad\",\"lastName\":\"Al Husainy\",\"roles\":[\"ADMIN\",\"SUPPORT\"],\"phone\":\"+962785295462\",\"balance\":null,\"accountId\":null,\"packagesUnitsSum\":null,\"isAdminLevel\":true,\"timezone\":\"Asia\\/Riyadh\",\"account\":null});\n    });\n\n            \n    window.analytics.ready(function() {\n      analytics.group(\"Unifonic_integration\", null);\n    });\n\n  \n</script>\n<!-- end Segment -->\n<header id=\"top-bar\" class=\"top-bar is-admin\">\n    <ul class=\"top-bar__left\">\n        <li class=\"top-bar__item products\">\n            <button id=\"top-bar__button\" class=\"top-bar__item--btn services\" tracking=\"UC Dashboard\" tracking-property=\"Services Button\" tracking-property-value=\"true\">\n                <i class=\"far fa-bars\"></i>\n                <span>Products</span>\n            </button>\n        </li>\n        <li class=\"top-bar__item top-bar--merged top-bar__item--border\">\n            <a class=\"top-bar__item--logo\" href=\"/\">\n                <img src=\"https://integration.dev.unifonic.com/build/images/unifonic_logo_white.png\" />\n            </a>\n        </li>\n    </ul>\n    <ul class=\"top-bar__right\">\n        \n        \n        <li class=\"top-bar__item top-bar__item-balance\n                        \"        \n        >\n                    </li>\n\n        <li class=\"top-bar__item top-bar__item-balance\n             top-bar--no-padding             \"        \n        >\n                    </li>\n\n        <li class=\"top-bar__item top-bar--merged top-bar__item--border\">\n            <i class=\"icon far fa-user-clock\"></i>\n\n            <div class=\"profile__info--balance-tooltip profile__info--balance-wrapper\">\n                <i class=\"fas fa-triangle\"></i>\n                \n                <div class=\"profile__info--balance\">Timezone</div> \n                <div class=\"profile__info--balance-value\">Asia/Riyadh</div>\n            </div>\n        </li>\n        <li class=\"top-bar__item top-bar__item-timezone top-bar--no-padding\">\n            <div class=\"profile__info--balance-wrapper\">\n                <span class=\"profile__info--name\">Timezone</span>\n                <span class=\"profile__info--account\">Asia/Riyadh</span>\n            </div>\n        </li>\n\n        <li class=\"top-bar__item top-bar--merged top-bar__item--border top-bar__avatar\">\n            <i class=\"icon far fa-user-circle\"></i>\n\n            <div class=\"profile__info--user-tooltip profile__info--balance-wrapper\">\n                <i class=\"fas fa-triangle\"></i>\n                \n                <div class=\"profile__info--balance\">Ahmad Al Husainy</div> \n                            </div>\n        </li>\n        <li class=\"top-bar__item top-bar--no-padding top-bar__item-user\" data-test=\"user_dropdown\" data-toggle=\"dropdown\">\n            <div class=\"profile__info--balance-wrapper\">\n                <span class=\"profile__info--name\">Ahmad Al Husainy</span>\n                            </div>\n        </li>\n\n        <li class=\"top-bar__item top-bar__item-dropdown\" data-test=\"user_dropdown\">\n            <i class=\"far fa-chevron-down\" data-toggle=\"dropdown\"></i>\n\n            <div class=\"dropdown-menu dropdown-menu-right dropdown--primary\" data-test=\"logout_button\">\n                        <ul class=\"nav\">\n                                                                                            <li class=\"dropdown-item first\">                    <a href=\"https://integration.dev.unifonic.com/profile\"><span class=\"icon icon far fa-user \"></span> <span class=\"nav-item-name\">Profile</span>\n    <i class=\"far fa-angle-right\"></i>\n</a>                                \n            </li>\n            \n                                                                                    <li class=\"dropdown-item last\">                    <a href=\"/logout\"><span class=\"icon icon far fa-sign-out-alt \"></span> <span class=\"nav-item-name\">Logout</span>\n    <i class=\"far fa-angle-right\"></i>\n</a>                                \n            </li>\n            \n\n    </ul>\n\n            </div>\n        </li>\n    </ul>\n</header>\n\n<aside id=\"menu_global\" class=\"app-menu app-menu--global\">\n    <!-- start: sidebar-content -->\n    <div id=\"app-menu__main\" class=\"sidebar-content\">\n        <!-- start: navigation -->\n        <nav class=\"nav-sidebar\">\n                    <ul class=\"nav\">\n                                                                                            <li class=\"nav-head first\">                    <span><span class=\"nav-item-name\">Products</span>\n    <i class=\"far fa-angle-right\"></i>\n</span>                                \n            </li>\n            \n                                                                                    <li class=\"nav-group product\">                    <a href=\"https://integration.dev.unifonic.com\"><span class=\"nav-item-name\">Unifonic Cloud</span>\n    <i class=\"far fa-angle-right\"></i>\n</a>                                \n            </li>\n            \n                                                                                    <li class=\"nav-group product\">                    <a href=\"https://communication.integration.dev.unifonic.com\"><span class=\"nav-item-name\">Communication Cloud</span>\n    <i class=\"far fa-angle-right\"></i>\n</a>                                \n            </li>\n            \n                                                                                    <li class=\"nav-head\">                    <span><span class=\"nav-item-name\">Applications</span>\n    <i class=\"far fa-angle-right\"></i>\n</span>                                \n            </li>\n            \n                                                                                    <li class=\"nav-group product\">                    <a href=\"https://conv.integration.dev.unifonic.com\"><span class=\"nav-item-name\">Conversations</span>\n    <i class=\"far fa-angle-right\"></i>\n</a>                                \n            </li>\n            \n                                                                                    <li class=\"nav-group product\">                    <a href=\"https://communication.integration.dev.unifonic.com/campaigns\"><span class=\"nav-item-name\">Campaigns</span>\n    <i class=\"far fa-angle-right\"></i>\n</a>                                \n            </li>\n            \n                            \n                            \n                                                                                    <li class=\"nav-group product\">                    <a href=\"http://dev.notify.cloud.unifonic.com\"><span class=\"nav-item-name\">Notify</span>\n    <i class=\"far fa-angle-right\"></i>\n</a>                                \n            </li>\n            \n                            \n                            \n                            \n                            \n                            \n\n    </ul>\n\n        </nav>\n    </div>\n    <!--/ end: sidebar-content -->\n</aside>\n"
  end

  def normal_topbar
    "<!-- start Segment -->\n<script type=\"text/javascript\">\n  !function(){var analytics=window.analytics=window.analytics||[];if(!analytics.initialize)if(analytics.invoked)window.console&&console.error&&console.error(\"Segment snippet included twice.\");else{analytics.invoked=!0;analytics.methods=[\"trackSubmit\",\"trackClick\",\"trackLink\",\"trackForm\",\"pageview\",\"identify\",\"reset\",\"group\",\"track\",\"ready\",\"alias\",\"debug\",\"page\",\"once\",\"off\",\"on\"];analytics.factory=function(t){return function(){var e=Array.prototype.slice.call(arguments);e.unshift(t);analytics.push(e);return analytics}};for(var t=0;t<analytics.methods.length;t++){var e=analytics.methods[t];analytics[e]=analytics.factory(e)}analytics.load=function(t,e){var n=document.createElement(\"script\");n.type=\"text/javascript\";n.async=!0;n.src=\"https://cdn.segment.com/analytics.js/v1/\"+t+\"/analytics.min.js\";var a=document.getElementsByTagName(\"script\")[0];a.parentNode.insertBefore(n,a);analytics._loadOptions=e};analytics.SNIPPET_VERSION=\"4.1.0\";\n    analytics.load(\"MZTSZupItW5i4M0ipP4VsnfUWzSPrDG6\");\n\n          analytics.page();\n      }}();\n\n  \n    \n    \n    window.analytics.ready(function() {\n        analytics.identify(\"f16dd21e-a5f1-4031-95e4-632dff5bac4a_integration\", {});\n    });\n\n            \n    window.analytics.ready(function() {\n      analytics.group(\"Unifonic_integration\", null);\n    });\n\n  \n</script>\n<!-- end Segment -->\n<header id=\"top-bar\" class=\"top-bar \">\n    <ul class=\"top-bar__left\">\n        <li class=\"top-bar__item products\">\n            <button id=\"top-bar__button\" class=\"top-bar__item--btn services\" tracking=\"UC Dashboard\" tracking-property=\"Services Button\" tracking-property-value=\"true\">\n                <i class=\"far fa-bars\"></i>\n                <span>Products</span>\n            </button>\n        </li>\n        <li class=\"top-bar__item top-bar--merged top-bar__item--border\">\n            <a class=\"top-bar__item--logo\" href=\"/\">\n                <img src=\"https://integration.dev.unifonic.com/build/images/unifonic_logo_white.png\" />\n            </a>\n        </li>\n    </ul>\n    <ul class=\"top-bar__right top-bar__impersonation\">\n                    <li class=\"top-bar__item top-bar__item--impersonation top-bar--merged\">\n                <a class=\"impersonation__link\" href=\"https://integration.dev.unifonic.com/impersonate/stop\">\n                    <i class=\"icon far fa-stop-circle\"></i>\n                </a>\n                            </li>\n            <li class=\"top-bar__item top-bar__item--impersonation top-bar--no-padding text--center\">\n                <p class=\"impersonation__text\">Impersonating</p>\n            </li>\n        \n           \n            <li class=\"top-bar__item top-bar--merged top-bar__item--border\">\n                <i class=\"icon far fa-wallet\"></i>\n\n                <div class=\"profile__info--balance-tooltip profile__info--balance-wrapper\">\n                    <i class=\"fas fa-triangle\"></i>\n\n                                            <div class=\"profile__info--balance\">Units</div>\n                        <div class=\"profile__info--balance-value\">991</div>\n                                                                <div class=\"profile__info--balance profile__info--space-top\">Balance</div> \n                        <div class=\"profile__info--balance-value\">USD 76.54</div>\n                                    </div>\n            </li>\n        \n        <li class=\"top-bar__item top-bar__item-balance\n             top-bar__item-balance--permitted              top-bar--merged top-bar--no-padding \"        \n        >\n                            <div class=\"profile__info--balance-wrapper\">\n                    <div class=\"profile__info--balance\">Units</div>\n                    <div class=\"profile__info--balance-value\">991</div>\n\n                    <div class=\"profile__info--balance-tooltip profile__info--balance-wrapper\">\n                        <i class=\"fas fa-triangle\"></i>\n\n                        <div class=\"profile__info--balance\">Units</div>\n                        <div class=\"profile__info--balance-value\">991</div>\n                    </div>\n                </div>\n\n                    </li>\n\n        <li class=\"top-bar__item top-bar__item-balance\n                         top-bar__item-balance--permitted \"        \n        >\n                            <div class=\"profile__info--balance-wrapper\">\n                    <div class=\"profile__info--balance\">Balance</div>\n                    <div class=\"profile__info--balance-value\">USD 76</div>\n\n                    <div class=\"profile__info--balance-tooltip profile__info--balance-wrapper\">\n                        <i class=\"fas fa-triangle\"></i>\n                        \n                        <div class=\"profile__info--balance\">Balance</div> \n                        <div class=\"profile__info--balance-value\">USD 76.54</div>\n                    </div>\n                </div>\n                    </li>\n\n        <li class=\"top-bar__item top-bar--merged top-bar__item--border\">\n            <i class=\"icon far fa-user-clock\"></i>\n\n            <div class=\"profile__info--balance-tooltip profile__info--balance-wrapper\">\n                <i class=\"fas fa-triangle\"></i>\n                \n                <div class=\"profile__info--balance\">Timezone</div> \n                <div class=\"profile__info--balance-value\">Asia/Riyadh</div>\n            </div>\n        </li>\n        <li class=\"top-bar__item top-bar__item-timezone top-bar--no-padding\">\n            <div class=\"profile__info--balance-wrapper\">\n                <span class=\"profile__info--name\">Timezone</span>\n                <span class=\"profile__info--account\">Asia/Riyadh</span>\n            </div>\n        </li>\n\n        <li class=\"top-bar__item top-bar--merged top-bar__item--border top-bar__avatar\">\n            <i class=\"icon far fa-user-circle\"></i>\n\n            <div class=\"profile__info--user-tooltip profile__info--balance-wrapper\">\n                <i class=\"fas fa-triangle\"></i>\n                \n                <div class=\"profile__info--balance\">Morni KSAAA</div> \n                                    <div class=\"profile__info--balance-value\">Morni KSA</div>\n                            </div>\n        </li>\n        <li class=\"top-bar__item top-bar--no-padding top-bar__item-user\" data-test=\"user_dropdown\" data-toggle=\"dropdown\">\n            <div class=\"profile__info--balance-wrapper\">\n                <span class=\"profile__info--name\">Morni KSAAA</span>\n                                    <span class=\"profile__info--account\">Morni KSA</span>\n                            </div>\n        </li>\n\n        <li class=\"top-bar__item top-bar__item-dropdown\" data-test=\"user_dropdown\">\n            <i class=\"far fa-chevron-down\" data-toggle=\"dropdown\"></i>\n\n            <div class=\"dropdown-menu dropdown-menu-right dropdown--primary\" data-test=\"logout_button\">\n                        <ul class=\"nav\">\n                                                                                            <li class=\"dropdown-item first\">                    <a href=\"https://integration.dev.unifonic.com/profile\"><span class=\"icon icon far fa-user \"></span> <span class=\"nav-item-name\">Profile</span>\n    <i class=\"far fa-angle-right\"></i>\n</a>                                \n            </li>\n            \n                                                                                    <li class=\"dropdown-item last\">                    <a href=\"/logout\"><span class=\"icon icon far fa-sign-out-alt \"></span> <span class=\"nav-item-name\">Logout</span>\n    <i class=\"far fa-angle-right\"></i>\n</a>                                \n            </li>\n            \n\n    </ul>\n\n            </div>\n        </li>\n    </ul>\n</header>\n\n<aside id=\"menu_global\" class=\"app-menu app-menu--global\">\n    <!-- start: sidebar-content -->\n    <div id=\"app-menu__main\" class=\"sidebar-content\">\n        <!-- start: navigation -->\n        <nav class=\"nav-sidebar\">\n                    <ul class=\"nav\">\n                                                                                            <li class=\"nav-head first\">                    <span><span class=\"nav-item-name\">Products</span>\n    <i class=\"far fa-angle-right\"></i>\n</span>                                \n            </li>\n            \n                                                                                    <li class=\"nav-group product\">                    <a href=\"https://integration.dev.unifonic.com\"><span class=\"nav-item-name\">Unifonic Cloud</span>\n    <i class=\"far fa-angle-right\"></i>\n</a>                                \n            </li>\n            \n                                                                                    <li class=\"nav-group product\">                    <a href=\"https://communication.integration.dev.unifonic.com\"><span class=\"nav-item-name\">Communication Cloud</span>\n    <i class=\"far fa-angle-right\"></i>\n</a>                                \n            </li>\n            \n                                                                                    <li class=\"nav-head\">                    <span><span class=\"nav-item-name\">Applications</span>\n    <i class=\"far fa-angle-right\"></i>\n</span>                                \n            </li>\n            \n                                                                                    <li class=\"nav-group product\">                    <a href=\"https://conv.integration.dev.unifonic.com\"><span class=\"nav-item-name\">Conversations</span>\n    <i class=\"far fa-angle-right\"></i>\n</a>                                \n            </li>\n            \n                            \n                                                                                    <li class=\"nav-group product\">                    <a href=\"https://conv.integration.dev.unifonic.com/integrations\"><span class=\"nav-item-name\">Slack for support</span>\n    <i class=\"far fa-angle-right\"></i>\n</a>                                \n            </li>\n            \n                                                                                    <li class=\"nav-group product\">                    <a href=\"https://conv.integration.dev.unifonic.com/integrations/bot-builder\"><span class=\"nav-item-name\">Bot Builder</span>\n    <i class=\"far fa-angle-right\"></i>\n</a>                                \n            </li>\n            \n                                                                                    <li class=\"nav-group product\">                    <a href=\"http://dev.notify.cloud.unifonic.com\"><span class=\"nav-item-name\">Notify</span>\n    <i class=\"far fa-angle-right\"></i>\n</a>                                \n            </li>\n            \n                                                                                    <li class=\"nav-head\">                    <span><span class=\"nav-item-name\">Store</span>\n    <i class=\"far fa-angle-right\"></i>\n</span>                                \n            </li>\n            \n                                                                                    <li class=\"nav-group product\">                    <a href=\"https://integration.dev.unifonic.com/store/top-up\"><span class=\"nav-item-name\">Top Up</span>\n    <i class=\"far fa-angle-right\"></i>\n</a>                                \n            </li>\n            \n                                                                                    <li class=\"nav-group product\">                    <a href=\"http://dev.platform.utilities.unifonic.com/marketplace/applications\"><span class=\"nav-item-name\">Marketplace</span>\n    <i class=\"far fa-angle-right\"></i>\n</a>                                \n            </li>\n            \n                            \n                            \n\n    </ul>\n\n        </nav>\n    </div>\n    <!--/ end: sidebar-content -->\n</aside>\n"
  end
end
