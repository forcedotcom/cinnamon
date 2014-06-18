function gotomenu(url) {
    document.location.href = url;
}

function ToggleBtnLabel(ctrl) {
    ctrl.value = (ctrl.value === '+' ? '-' : '+');
}

function IsExpanded(ctrl) {
    return (ctrl.value === '-');
}

function ToggleAll(e) {
    var cExpanded = 0;
    $('h2.trigger', $(e).closest('tr')).each(function() {
        if (!IsExpanded(this.firstChild)) {
            $(this).toggleClass('active').next().slideToggle('fast');
            ToggleBtnLabel($(this).find("input").get(0));
            cExpanded++;
        }
    });

    if (cExpanded === 0) {
        $('h2.trigger', $(e).closest('tr')).each(function() {
            $(this).toggleClass('active').next().slideToggle('fast');
            ToggleBtnLabel($(this).find("input").get(0));
        });
    }
}