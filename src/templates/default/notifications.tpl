<?php
function parseInfo($n) {
    $info = json_decode($n['info'], true);
    switch ($n['type']) {
        case 'profile_view':
            $result = str_replace('{user}', '<b load-modal="profile" load-path="/id'.$n['sender_id'].'?short">'.$info['sender_nick'].'</b>', View::lang('notifi_viev_info'));
            break;
    }
    return $result;
}
?>
{% for $key => $n in $GLOBALS['list'] %}
<div class="notification">
    <img src="/uploads/avatars/id{{ $n['sender_id'] }}.jpg" />
    <p>{{ parseInfo($n) }}</p>
    <span delete="{{ $n['id'] }}">| delete |</span>
    <span id="tmp-ntime-{{ $key }}">__.__.__ __:__</span>
    <script>$('#tmp-ntime-{{ $key }}').html(parseTime({{ $n['timestamp'] }}, false));</script>
</div>
{% endfor %}
<span remove>| notifi_delete_all |</span>
{% if !count($GLOBALS['list']) %}
<div style="text-align: center; padding: 5px;">
    <h2>| notifi_title |</h2>
    <img src="/public/img/icons/note.png" />

</div>
{% endif %}

<script>
$('.notification > [delete]').click(e => {
    $.get('/helper/remove_notification?id=' + $(e.target).attr('delete'), res => {
        $(e.target).parent().remove();
        $('[notifications]').click();
    });
});
</script>
