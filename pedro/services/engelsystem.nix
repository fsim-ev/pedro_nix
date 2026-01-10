{ pkgs, config, ... }:
{
  age.secrets = {
    engelsystem-sso-client-id.file = ../secrets/engelsystem-sso-client-id.age;
    engelsystem-sso-client-secret.file = ../secrets/engelsystem-sso-client-secret.age;
  };

  services.engelsystem = {
    enable = true;
    domain = "katzen.fsim-ev.de";
    createDatabase = true;
    package = pkgs.engelsystem.overrideAttrs {
      patches = (../patches/engelsystem-allow_colliding.patch);
    };
    # configuration options with explanations can be found at
    # https://github.com/engelsystem/engelsystem/blob/main/config/config.default.php
    settings = {
      database = {
        database = "engelsystem";
        host = "localhost";
        username = "engelsystem";
        # password._secret = "/path/to/secret/file";
      };
      # api_keys = "";
      maintenance = false;
      app_name = "Kami-Katzensystem";
      # production/development (set development for debugging messages)
      environment = "production";
      # url = "";
      # header_items = "";
      footer_items = {
        # disabling FAQ does not work (why?)
        # FAQ = none;
        Contact = "mailto:fachschaft_im@oth-regensburg.de";
        Website = "https://fsim-ev.de";
        Chat = "https://chat.fsim-ev.de";
        Cloud = "https://cloud.fsim-ev.de";
        Pad = "https://pad.fsim-ev.de";
        Wiki = "https://wiki.fsim-ev.de";
      };
      faq_text = ''
        deal with it yourself
         I can't help you'';
      documentation_url = "https://wiki.fsim-ev.de";
      # email = {
      #   driver = "smtp";
      #   from = {
      #     address = "fachschaft_im@oth-regensburg.de";
      #     name = "Engelsystem";
      #   };
      #   host = "localhost";
      #   port = 587;
      #   encryption = "tls";
      #   username = "mail_username";
      #   password = "mail_password";
      #   sendmail = "/usr/sbin/sendmail -bs";
      # };
      privacy_email = "fachschaft_im@oth-regensburg.de";
      enable_email_goodie = "false";
      # setup_admin_password = "testpasswd"; # funktioniert nicht -> ist "asdfasdf", sofort beim 1. login aendern
      theme = "1";
      themes = {
        # disable themes here
      };
      home_site = "user_shifts";
      # display_news = "20";
      registration_enabled = true;
      # external_registration_url = "https://someURL.here";
      required_user_fields = {
        pronoun = false;
        firstname = false;
        lastname = false;
        tshirt_size = false;
        mobile = false;
        dect = false;
      };
      signup_requires_arrival = false;
      autoarrive = true;
      supporters_can_promote = false;
      signup_advance_hours = 0;
      signup_post_minutes = 0;
      signup_post_fraction = 0;
      last_unsubscribe = 3;
      # password_algorithm = PASSWORD_DEFAULT;
      password_min_length = 6;
      enable_password = false;
      enable_dect = false;
      enable_mobile_show = false;
      username_regex = "/(^p{L}p{N}_.-]+)/ui";
      enable_full_name = false;
      display_full_name = false;
      enable_pronoun = false;
      enable_planned_arrival = false;
      enable_force_active = false;
      enable_self_worklog = false;
      goodie_type = "none";
      enable_voucher = false;
      max_freeloadable_shifts = 10;
      # disable_user_view_columns = {};
      timezone = "Europe/Berlin";
      night_shifts = {
        enabled = false;
        start = 0;
        end = 8;
        multiplier = 2;
      };
      voucher_settings = {
        initial_vouchers = 0;
        shifts_per_voucher = 0;
        hours_per_voucher = 2;
        voucher_start = null;
      };
      driving_license_enabled = false;
      ifsg_enabled = false;
      ifsg_light_enabled = false;
      locales = {
        de_DE = "Deutsch";
        en_US = "English";
      };
      default_locale = "de_DE";
      # tshirt_sizes = {
      #   S = "Small Straight-Cut";
      #   S-F = "Small Fitted-Cut";
      #   M = "Medium Straight-Cut";
      #   M-F = "Medium Fitted-Cut";
      #   L    = "Large Straight-Cut";
      #   L-F  = "Large Fitted-Cut";
      #   XL   = "XLarge Straight-Cut";
      #   XL-F = "XLarge Fitted-Cut";
      #   2XL  = "2XLarge Straight-Cut";
      #   3XL  = "3XLarge Straight-Cut";
      #   4XL  = "4XLarge Straight-Cut";
      # };
      # tshirt_link = "";
      enabel_day_of_event = true;
      event_has_day0 = true;
      filter_max_duration = 0;
      session = {
        driver = "pdo";
        name = "session";
        lifetime = 30;
      };
      # trusted_proxies = "127.0.0.0/8";
      add_headers = true;
      headers = {
        X-Content-Type-Options = "nosniff";
        X-Frame-Options = "sameorigin";
        Referrer-Policy = "strict-origin-when-cross-origin";
        # Conent-Security-Policy = ""
        X-XSS-Protection = "1; mode=block";
        # Feature-Policy = "autoplay \'none\'";
      };
      credits = {
        Contribution = "Please just skip this. There is nothing to see here.";
      };
      # var_dump_server = {

      #   hsot = "127.0.0.1";
      #   port = "9912";
      #   enable = false;
      # };
      oauth = {
        sso = {
          name = "Authentik";
          client_id = {_secret = config.age.secrets.engelsystem-sso-client-id.path; };
          client_secret = {_secret = config.age.secrets.engelsystem-sso-client-secret.path; };
          url_auth = "https://idp.fsim-ev.de/application/o/authorize/";
          url_token = "https://idp.fsim-ev.de/application/o/token/";
          url_info = "https://idp.fsim-ev.de/application/o/userinfo/";
          scope = [
            "openid"
            "email"
            "profile"
          ];
          # id = "ocs.data.id";
          # username = "ocs.data.displayname";
          # email = "ocs.data.email";
          id = "nickname"; # rz-kennung
          username = "name";
          email = "email";
          # first_name = "given_name";
          # last_name = "family_name";
          # url = "https://cloud.fsim-ev.de/";
          # url = "https://keycloak.fsim-ev.de/realms/default/account/";
          # nested_info = true;
          # hidden = true;
          mark_arrived = true;
          enable_password = false;
          allow_registration = true;
          # groups = "ocs.data.groups";
          # teams = {
          #   IM_Studenten = 1;
          # };
          # admins = {
          #   "IM_Fachschaft_Administratoren" = [ 60 65 80 90 ];
          # };
        };
      };
    };
  };

  services.nginx.virtualHosts."katzen.fsim-ev.de" = {
    forceSSL = true;
    enableACME = true;
  };
}
