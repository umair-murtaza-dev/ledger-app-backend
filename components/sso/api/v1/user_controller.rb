class Sso::Api::V1::UserController < Sso::Api::V1::ApplicationController
  def me
    # aa = {"id":"9aec00f8-c127-4481-bc2f-5e6f721c12e3","email":"dev@morniksa.com","first_name":"Morni","last_name":"KSAAA","phone":"+966555789465","roles":["ACCOUNT_USER","ACCOUNT_ADMIN"],"permissions":{"CC":{"PLAYGROUND_VOICE_TTS":["SEE"],"CAMPAIGN":["SEE_USER_OWN","DELETE_USER_OWN","CREATE","DELETE_OWN","SEE_OWN"],"TRAFFIC_REPORT":["SEE_OWN"],"DOCUMENTATION_LINK":["SEE"],"PLAYGROUND_VOICE_AUDIO_FILE":["SEE"],"PLAYGROUND_VOICE_NUMBER_MASKING":["SEE"],"VOICE_CALL_LOGS":["SEE_OWN"],"SENDER_NAME":["SEE_OWN","DEACTIVATE_OWN","CREATE_OWN","DELETE_OWN","EDIT_OWN","SHARE_OWN"],"APPS_ID":["EDIT_OWN","DELETE_OWN","CREATE","SEE_OWN"],"SENDER_NAME_AUTO_APPROVE":["APPROVE_OWN"],"APPS_VOICE":["CREATE","EDIT_OWN","SEE_OWN"],"DECRYPTED_MESSAGE_CONTENT":["DECRYPT_OWN"],"CONSUMPTION_REPORT":["SEE_OWN"],"CALLER":["SEE_OWN","CREATE"],"MESSAGE_LOG":["SEE_OWN"],"APPLICATION_SMPP_BIND_TYPE":["EDIT"]},"UC":{"NOTIFICATION_SETTINGS":["SEE_OWN","EDIT_OWN"],"USER_PROFILE":["SEE_OWN","EDIT_OWN"],"ACCOUNT":["SEE_OWN"],"SUB_ACCOUNT":["CREATE","EDIT_OWN","SEE_OWN"],"BALANCE":["SEE_OWN","TRANSFER"],"USER":["CREATE","EDIT_OWN","SEE_OWN"],"PAYMENT":["SEE_OWN"],"CONSUMPTION_REPORTS":["SEE_ALL"],"PACKAGE":["TRANSFER","SEE_OWN"],"TOP_UP":["PAY"],"TRANSFER_LOG":["EXPORT_OWN"],"TWO_FA":["EDIT_OWN"],"IMPERSONATE":["SEE_OWN"]},"CONV":{"BOT_BUILDER":["SEE_OWN","CREATE","EDIT_OWN"],"APPLICATION":["SEE_OWN","EDIT_OWN","CREATE"],"SLACK_FOR_SUPPORT":["SEE_OWN","CREATE"],"CUSTOMER":["CREATE","SEE_OWN"]},"NT":{"APP":["CREATE_OWN","DELETE_OWN","SEE_OWN","EDIT_OWN"],"CREDENTIAL":["DELETE_OWN","SEE_OWN","EDIT_OWN","CREATE_OWN"],"NOTIFICATION":["SEE_OWN"],"NOTIFICATION_LOG":["SEE_OWN"]},"AU":{"APP":["EDIT_OWN","CREATE_OWN","DELETE_OWN","SEE_OWN"],"VERIFICATION_LOG":["SEE_OWN"],"VERIFICATION":["SEE_OWN"]},"CC.CAMPAIGN":{"CAMPAIGNS_VOICE":["SEE_OWN","CREATE"],"AUDIO_LIBRARY":["SEE_OWN","CREATE"],"DIALS":["SEE_OWN"]},"MP":{"CONNECTOR":["EDIT_OWN","CREATE_OWN","SEE_OWN","DELETE_OWN"],"APPLICATION":["EDIT_OWN","SEE_OWN"]}},"system_settings":{"name":"Unifonic","logo":"https://integration.dev.unifonic.com/build/images/unifonic_logo.png","menuLogo":"https://integration.dev.unifonic.com/build/images/unifonic_logo_white.png","favIcon":"https://integration.dev.unifonic.com/build/images/unifonic_favicon.ico","appleTouchIcon":"https://integration.dev.unifonic.com/build/images/unifonic_apple_touch_icon.png","emailFrom":"products@unifonic.com","emailSupport":"support@unifonic.com","mainUrl":"https://integration.dev.unifonic.com","domain":"integration.dev.unifonic.com","scheme":"https","isWhitelabelActive":false},"timezone":"Asia/Riyadh","is_admin_level":false,"account":{"id":"096dbece-f82e-11e8-809b-0252151e4411","provisioning_id":2,"charging_id":2,"crm_id":"160818142823","name":"Morni KSA","balance":2394397.51,"country":"Saudi Arabia","account_manager_name":"","account_manager_email":"","type":nil,"category":nil,"two_factory_authentication_enabled":false},"currency":{"id":6,"key":"usd","name":"USD","code":"USD"},"settings":{"redirect_uri":"http://dev.platform.utilities.unifonic.com/sender-id-requests","logout_url":"https://integration.dev.unifonic.com/logout","me_url":"https://integration.dev.unifonic.com/app/api/v2/user/me","auth_url":"https://integration.dev.unifonic.com/oauth/v2/auth?response_type=code&client_id=c120f7b5-d88d-4b16-91dc-e7f6076103d9_53fi4evfgpwkww44o40cg0o0cok8o44s4o440w88884s8so0wc&redirect_uri=http://dev.platform.utilities.unifonic.com/check_login"}}
    render json: Sso::Presenter::Me.new(dto: current_user).present
  end

  def top_bar
    # aa = '<!-- start Segment -->
    # <script type="text/javascript">
    #   !function(){var analytics=window.analytics=window.analytics||[];if(!analytics.initialize)if(analytics.invoked)window.console&&console.error&&console.error("Segment snippet included twice.");else{analytics.invoked=!0;analytics.methods=["trackSubmit","trackClick","trackLink","trackForm","pageview","identify","reset","group","track","ready","alias","debug","page","once","off","on"];analytics.factory=function(t){return function(){var e=Array.prototype.slice.call(arguments);e.unshift(t);analytics.push(e);return analytics}};for(var t=0;t<analytics.methods.length;t++){var e=analytics.methods[t];analytics[e]=analytics.factory(e)}analytics.load=function(t,e){var n=document.createElement("script");n.type="text/javascript";n.async=!0;n.src="https://cdn.segment.com/analytics.js/v1/"+t+"/analytics.min.js";var a=document.getElementsByTagName("script")[0];a.parentNode.insertBefore(n,a);analytics._loadOptions=e};analytics.SNIPPET_VERSION="4.1.0";
    #     analytics.load("MZTSZupItW5i4M0ipP4VsnfUWzSPrDG6");
    #
    #           analytics.page();
    #       }}();
    #
    # </script>
    # <!-- end Segment -->
    # <header id="top-bar" class="top-bar ">
    #     <ul class="top-bar__left">
    #         <li class="top-bar__item products">
    #             <button id="top-bar__button" class="top-bar__item--btn services" tracking="UC Dashboard" tracking-property="Services Button" tracking-property-value="true">
    #                 <i class="far fa-bars"></i>
    #                 <i class="far fa-chevron-left"></i>
    #             </button>
    #         </li>
    #         <li class="top-bar__item top-bar--merged top-bar__item--border">
    #             <a class="top-bar__item--logo" href="/">
    #                 <img src="https://integration.dev.unifonic.com/build/images/unifonic_logo_white.png" />
    #             </a>
    #         </li>
    #     </ul>
    #     <ul class="top-bar__right">
    #
    #
    #             <li class="top-bar__item top-bar--merged top-bar__item--border">
    #                 <i class="icon far fa-wallet"></i>
    #
    #                 <div class="profile__info--balance-tooltip profile__info--balance-wrapper">
    #                     <i class="fas fa-triangle"></i>
    #
    #                                             <div class="profile__info--balance">Units</div>
    #                         <div class="profile__info--balance-value">449,115</div>
    #                                                                 <div class="profile__info--balance profile__info--space-top">Balance</div>
    #                         <div class="profile__info--balance-value">USD 2,394,397.51</div>
    #                                     </div>
    #             </li>
    #
    #         <li class="top-bar__item top-bar__item-balance
    #              top-bar__item-balance--permitted              top-bar--merged top-bar--no-padding "
    #         >
    #                             <div class="profile__info--balance-wrapper">
    #                     <div class="profile__info--balance">Units</div>
    #                     <div class="profile__info--balance-value">449K</div>
    #
    #                     <div class="profile__info--balance-tooltip profile__info--balance-wrapper">
    #                         <i class="fas fa-triangle"></i>
    #
    #                         <div class="profile__info--balance">Units</div>
    #                         <div class="profile__info--balance-value">449,115</div>
    #                     </div>
    #                 </div>
    #
    #                     </li>
    #
    #         <li class="top-bar__item top-bar__item-balance
    #                          top-bar__item-balance--permitted "
    #         >
    #                             <div class="profile__info--balance-wrapper">
    #                     <div class="profile__info--balance">Balance</div>
    #                     <div class="profile__info--balance-value">USD 2 M</div>
    #
    #                     <div class="profile__info--balance-tooltip profile__info--balance-wrapper">
    #                         <i class="fas fa-triangle"></i>
    #
    #                         <div class="profile__info--balance">Balance</div>
    #                         <div class="profile__info--balance-value">USD 2,394,397.51</div>
    #                     </div>
    #                 </div>
    #                     </li>
    #
    #         <li class="top-bar__item top-bar--merged top-bar__item--border">
    #             <i class="icon far fa-user-clock"></i>
    #
    #             <div class="profile__info--balance-tooltip profile__info--balance-wrapper">
    #                 <i class="fas fa-triangle"></i>
    #
    #                 <div class="profile__info--balance">Timezone</div>
    #                 <div class="profile__info--balance-value">Asia/Riyadh</div>
    #             </div>
    #         </li>
    #         <li class="top-bar__item top-bar__item-timezone top-bar--no-padding">
    #             <div class="profile__info--balance-wrapper">
    #                 <span class="profile__info--name">Timezone</span>
    #                 <span class="profile__info--account">Asia/Riyadh</span>
    #             </div>
    #         </li>
    #
    #         <li class="top-bar__item top-bar--merged top-bar__item--border top-bar__avatar">
    #             <i class="icon far fa-user-circle"></i>
    #
    #             <div class="profile__info--user-tooltip profile__info--balance-wrapper">
    #                 <i class="fas fa-triangle"></i>
    #
    #                 <div class="profile__info--balance">Morni KSAAA</div>
    #                                     <div class="profile__info--balance-value">Morni KSA</div>
    #                             </div>
    #         </li>
    #         <li class="top-bar__item top-bar--no-padding top-bar__item-user" data-test="user_dropdown" data-toggle="dropdown">
    #             <div class="profile__info--balance-wrapper">
    #                 <span class="profile__info--name">Morni KSAAA</span>
    #                                     <span class="profile__info--account">Morni KSA</span>
    #                             </div>
    #         </li>
    #
    #         <li class="top-bar__item top-bar__item-dropdown" data-test="user_dropdown">
    #             <i class="far fa-chevron-down" data-toggle="dropdown"></i>
    #
    #             <div class="dropdown-menu dropdown-menu-right dropdown--primary" data-test="logout_button">
    #                         <ul class="nav">
    #                                                                                             <li class="dropdown-item first">                    <a href="https://integration.dev.unifonic.com/profile"><span class="icon icon far fa-user "></span> <span class="nav-item-name">Profile</span>
    #     <i class="far fa-angle-right"></i>
    # </a>
    #             </li>
    #
    #                                                                                     <li class="dropdown-item last">                    <a href="/logout"><span class="icon icon far fa-sign-out-alt "></span> <span class="nav-item-name">Logout</span>
    #     <i class="far fa-angle-right"></i>
    # </a>
    #             </li>
    #
    #
    #     </ul>
    #
    #             </div>
    #         </li>
    #     </ul>
    # </header>
    #
    # <aside id="menu_global" class="app-menu app-menu--global">
    #     <!-- start: sidebar-content -->
    #     <div id="app-menu__main" class="sidebar-content">
    #         <!-- start: navigation -->
    #         <nav class="nav-sidebar">
    #                     <ul class="nav">
    #                                                                                             <li class="nav-head first">                    <span><span class="nav-item-name">Products</span>
    #     <i class="far fa-angle-right"></i>
    # </span>
    #             </li>
    #
    #                                                                                     <li class="nav-group product">                    <a href="https://integration.dev.unifonic.com"><span class="nav-item-name">Unifonic Cloud</span>
    #     <i class="far fa-angle-right"></i>
    # </a>
    #             </li>
    #
    #                                                                                     <li class="nav-group product">                    <a href="https://communication.integration.dev.unifonic.com"><span class="nav-item-name">Communication cloud</span>
    #     <i class="far fa-angle-right"></i>
    # </a>
    #             </li>
    #
    #                                                                                     <li class="nav-head">                    <span><span class="nav-item-name">Applications</span>
    #     <i class="far fa-angle-right"></i>
    # </span>
    #             </li>
    #
    #                                                                                     <li class="nav-group product">                    <a href="https://conversation.integration.dev.unifonic.com"><span class="nav-item-name">Conversations</span>
    #     <i class="far fa-angle-right"></i>
    # </a>
    #             </li>
    #
    #                                                                                     <li class="nav-group product">                    <a href="https://communication.integration.dev.unifonic.com/campaigns"><span class="nav-item-name">Campaigns</span>
    #     <i class="far fa-angle-right"></i>
    # </a>
    #             </li>
    #
    #                                                                                     <li class="nav-group product">                    <a href="https://conversation.integration.dev.unifonic.com/integrations"><span class="nav-item-name">Slack for support</span>
    #     <i class="far fa-angle-right"></i>
    # </a>
    #             </li>
    #
    #                                                                                     <li class="nav-group product">                    <a href="https://conversation.integration.dev.unifonic.com/integrations/bot-builder"><span class="nav-item-name">Bot Builder</span>
    #     <i class="far fa-angle-right"></i>
    # </a>
    #             </li>
    #
    #                                                                                     <li class="nav-group product">                    <a href="http://dev.notice.cloud.unifonic.com"><span class="nav-item-name">Notice</span>
    #     <i class="far fa-angle-right"></i>
    # </a>
    #             </li>
    #
    #                                                                                     <li class="nav-group product">                    <a href="http://dev.authenticate.cloud.unifonic.com"><span class="nav-item-name">Authenticate</span>
    #     <i class="far fa-angle-right"></i>
    # </a>
    #             </li>
    #
    #                                                                                     <li class="nav-head">                    <span><span class="nav-item-name">Store</span>
    #     <i class="far fa-angle-right"></i>
    # </span>
    #             </li>
    #
    #                                                                                     <li class="nav-group product">                    <a href="https://integration.dev.unifonic.com/store/top-up"><span class="nav-item-name">Top Up</span>
    #     <i class="far fa-angle-right"></i>
    # </a>
    #             </li>
    #
    #                                                                                     <li class="nav-group product">                    <a href="http://dev.platform.utilities.unifonic.com/marketplace/applications"><span class="nav-item-name">Marketplace</span>
    #     <i class="far fa-angle-right"></i>
    # </a>
    #             </li>
    #
    #
    #
    #
    #     </ul>
    #
    #         </nav>
    #     </div>
    #     <!--/ end: sidebar-content -->
    # </aside>'
    if is_mocked?
      render body: Mocking::Service.new(current_user.is_admin_level).topbar, content_type: 'text/html'
    else
      render body: UnifonicCloud::Auth::Service.new.top_bar(token: get_token), content_type: 'text/html'
    end
  end
end
