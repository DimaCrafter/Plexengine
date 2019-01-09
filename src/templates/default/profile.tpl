﻿<?php
    function getAbout($field) {
        if (isset($GLOBALS['profile_data']['about'][$field])) return $GLOBALS['profile_data']['about'][$field];
        else return View::lang('pr_info_none');
    }

    function getAccessLang() {
        switch ($GLOBALS['profile_data']['access']) {
            case 'admin':   $l = 'info_administrator'; break;
            case 'premium': $l = 'pr_info_vip';        break;
            case 'user':    $l = 'pr_info_user';       break;
        }
        return View::lang($l);
    }
?>
{% if !isset($_GET['short']) %}
<!DOCTYPE html>
<html profile>
    <head>
        <title>{{ $_CONFIG['site_name'] }}</title>
        <meta charset="UTF-8" />
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link rel="stylesheet" href="/public/css/profile.css" />
    </head>
    <body id="profile_wrapper">
{% else %}
        <i class="close"></i>
{% endif %}
        {% if !isset($GLOBALS['profile_data']) %}
        <h1 style="font-size: 32px;">| no_profile |</h1>
        <p style="font-size: 16px;">| no_profile_info |</p>
        <style>
            [profile] body,
            #profile_wrapper {
                padding: 5px 50px;
            }
        </style>
        {% else %}
        {% if isset($_SESSION['userdata']) %}
        <img class="my_avatar" src="/public/avatars/id{{ $_SESSION['userdata']['id'] }}.png" />
        <div id="profile_free_gifts">
            <h1>| free |</h1>
            <span>| free_gift_info |</span>
            <img class="gift" src="/public/img/test_gift.png" />
        </div>
        {% else %}
        <style>[profile] > body { margin: 15px auto; }</style>
        {% endif %}
        {% if !isset($_SESSION['userdata']) or $_SESSION['userdata']['id'] != $GLOBALS['profile_data']['id'] %}
        <style>i[edit] { display: none; }</style>
        {% endif %}
        <img src="/public/covers/id{{ $GLOBALS['profile_data']['id'] }}.png" />
        <i edit="cover" class="chat_icon_edit"></i>
        <div id="profile_top">
            <img width="180px" height="180px" src="/public/avatars/id{{ $GLOBALS['profile_data']['id'] }}.png" />
            <i edit="avatar" class="chat_icon_edit"></i>
            <span id="profile_status"><b>| pr_info_myid |</b> http://{{ $_SERVER['SERVER_NAME'] }}/id{{ $GLOBALS['profile_data']['id'] }}</span>
            <div style="flex: 1 1 100%;">
                <h1>
                    | pr_info | {{ $GLOBALS['profile_data']['nick'] }}
                    {% if $GLOBALS['profile_data']['verificated'] == 1 %}
                    <i tooltip="| verifed_info |" class="chat_icon_verificated"></i>
                    {% endif %}
                </h1>
                {% if $GLOBALS['profile_data']['last_online'] + 5 >= time() %}
                <span online>| status_chat |</span>
                <button onclick="write_fpr()" class="btn">| write_to |</button>
                {% else %}
                <span>| user_was_online | {{ date('d.m.Y H:i:s', $GLOBALS['profile_data']['last_online']) }}</span>
                {% endif %}
                <div class="access">
                    <i class="chat_icon_{{ $GLOBALS['profile_data']['access'] }}1"></i>
                    <b>{{ $GLOBALS['profile_data']['nick'] }}</b>
                    <span>{{ getAccessLang() }}</span>
                </div>
            </div>
        </div>
        <div id="profile_gifts">
            <div no-gifts>
                <i></i>
                <span>
                    {{ $GLOBALS['profile_data']['nick'] }}
                    {% if $GLOBALS['profile_data']['gender'] == 'male' %}| pr_info_to_gift_male |{% endif %}
                    {% if $GLOBALS['profile_data']['gender'] == 'female' %}| pr_info_to_gift_female |{% endif %}
                </span>
                {# <span>| pr_info_sh_all |</span> #}
            </div>
        </div>
        <div class="tabs">
            <div class="caption">
                <span tab-id="info" class="active">| pr_info_about |</span>
                <span tab-id="contacts">| pr_info_contacts |</span>
                <span tab-id="photos">| pr_info_photo |</span>
            </div>
            <form id="profile_about" tab-id="info" class="tab flex active">
                <div style="position: relative; flex: 1;">
                    <h1>| pr_info_about_me |</h1>
                    <p edit="info">{{ getAbout('info') }}</p>
                    <i edit class="chat_icon_edit"></i>
                    <br />
                    
                    <table>
                        <tr>
                            <td>| pr_info_date |</td>
                            <td>{{ $GLOBALS['profile_data']['date_of_birth'] }}</td>
                        </tr>
                        <tr>
                            <td>| pr_info_city |</td>
                            <td edit="city">{{ getAbout('city') }}</td>
                        </tr>
                        <tr>
                            <td>| pr_info_fam_status |</td>
                            <td edit="family_status">{{ getAbout('family_status') }}</td>
                        </tr>
                        <tr>
                            <td>| pr_info_work |</td>
                            <td edit="work">{{ getAbout('work') }}</td>
                        </tr>
                        <tr>
                            <td>| pr_info_www |</td>
                            <td edit="site">{{ getAbout('site') }}</td>
                        </tr>
                    </table>
                    <br />
                    <button style="display: none;" class="btn" type="submit">| apply |</button>
                </div>
                <img src="/public/img/zodiac/{{ $GLOBALS['profile_data']['zodiac'] }}.png">
            </form>
            <form id="profile_contacts" tab-id="contacts" class="tab">
                <div>
                    <i edit class="chat_icon_edit"></i>
                    <span edit="vk"><img src="/public/img/icons/vk.png" /> {{ getAbout('vk') }}</span>
                    <span edit="phone"><img src="/public/img/icons/phone.png" /> {{ getAbout('phone') }}</span>
                    <span edit="skype"><img src="/public/img/icons/skype.png" /> {{ getAbout('skype') }}</span>
                    <span edit="inst"><img src="/public/img/icons/inst.png" /> {{ getAbout('inst') }}</span>
                </div>
                <br />
                <button style="display: none;" class="btn" type="submit">| apply |</button>
            </form>
            <div tab-id="photos" class="tab"></div>
        </div>
        {% endif %}
        <script>
            $('#profile_about i[edit]').click(e => {
                if ($('#profile_about').attr('editing')) return;
                else {
                    var $about = $('#profile_about [edit="info"]');
                    var about_val = $about.html();
                    if (about_val == '| pr_info_none |') about_val = '';
                    $about.html($('<textarea maxlength="200">').html(about_val));
                    $('#profile_about tr > td[edit]:last-child').each((key, field) => {
                        var val = $(field).html();
                        if (val == '| pr_info_none |') val = '';
                        $(field).html($('<input maxlength="26">').val(val));
                    });
                    $('#profile_about button[type="submit"]').show();
                    $(e.target).hide();
                    $('#profile_about').attr('editing', true);
                }
            });

            $('#profile_about').on('submit', e => {
                e.preventDefault();
                var $btn = $('#profile_about button[type="submit"]');
                if ($('#profile_about button[type="submit"]').attr('disabled')) return false;
                var data = {};
                $btn.attr('disabled', true);

                $('#profile_about i[edit]').show();
                var $about = $('#profile_about [edit="info"] > textarea');
                data.info = $about.val();
                if (data.info.trim() == '') {
                    $about.parent().html('| pr_info_none |');
                    delete data.info;
                } else {
                    $about.parent().html(data.info);
                }

                $('#profile_about tr > td[edit]:last-child > input').each((key, field) => {
                    var val = $(field).val();
                    if (val.trim() == '') {
                        $(field).parent().html('| pr_info_none |');
                    } else {
                        $(field).parent().html(val);
                        data[$(field).parent().attr('edit')] = val;
                    }
                });

                Object.keys(data).forEach(k => data[k].trim() == '' && delete data[k]);
                $.post('/modules/Auth/profile_save', data, res => {
                    $btn.removeAttr('disabled');
                    $btn.hide();
                    $('#profile_about').removeAttr('editing');
                });
                return false;
            });
            
            $('#profile_contacts i[edit]').click(e => {
                if ($('#profile_contacts').attr('editing')) return;
                else {
                    $('#profile_contacts span[edit]').each((key, field) => {
                        var val = $(field).text().trim();
                        if (val == '| pr_info_none |') val = '';
                        var $img = $('img', field).clone();
                        $(field).html($('<input maxlength="26">').val(val)).prepend($img);
                    });
                    $('#profile_contacts button[type="submit"]').show();
                    $(e.target).hide();
                    $('#profile_contacts').attr('editing', true);
                }
            });

            $('#profile_contacts').on('submit', e => {
                e.preventDefault();
                var $btn = $('#profile_contacts button[type="submit"]');
                if ($('#profile_contacts button[type="submit"]').attr('disabled')) return false;
                var data = {};
                $btn.attr('disabled', true);

                $('#profile_contacts i[edit]').show();
                $('#profile_contacts span[edit]').each((key, field) => {
                    var val = $('input', field).val();
                    var $img = $('img', field).clone();
                    if (val.trim() == '') {
                        $(field).html('| pr_info_none |');
                    } else {
                        $(field).html(val);
                        data[$(field).attr('edit')] = val;
                    }
                    $(field).prepend($img);
                });

                Object.keys(data).forEach(k => data[k].trim() == '' && delete data[k]);
                $.post('/modules/Auth/profile_save', data, res => {
                    $btn.removeAttr('disabled');
                    $btn.hide();
                    $('#profile_contacts').removeAttr('editing');
                });
                return false;
            });

            function write_fpr () {
                if (window.location.pathname != '/') {
                    sessionStorage.setItem('write_to', '{{ $GLOBALS['profile_data']['nick'] }}');
                    window.location.pathname = '/';
                } else {
                    $('#chat chat-send-to > input').val('{{ $GLOBALS['profile_data']['nick'] }}');
                    $('#chat chat-input-wrapper > input').focus();
                    close_modal('profile');
                }
            }
        </script>
{% if !isset($_GET['short']) %}
    </body>
    <script src="/public/js/main.js"></script>
</html>
{% endif %}
