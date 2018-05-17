/**
 * Отображение текста сообщения в ЛС
 * @param id код сообщения
 * @param state изменять ли статус сообщения на прочитанное
 */
function viewMessage(id, state) {
    $.ajax({
        url: '/read',
        cache: false,
        type: 'post',
        data: "id=" + id + "&state=" + state,
        beforeSend: function() {
            $('.text').text('Загрузка...');
        },
        success: function(res) {
            $('.text').text(res.output);
            if (state == 1) {
                if ($('#d' + id).hasClass('new')) {
                    $('#d' + id).removeClass('new');
                }
                if ($('#m' + id).hasClass('new')) {
                    $('#m' + id).removeClass('new');
                }
            }
            $('tr[id^="d"]').each(function(){
                $(this).removeClass('current');
            })
            $('td[id^="m"]').each(function(){
                $(this).removeClass('current');
            })
            $('#d' + id).addClass('current');
            $('#m' + id).addClass('current');
        },
        error: function(err){
            console.error(err);
        }
    });
}

/**
 * Цитирование сообщения
 * @param id код сообщения
 * @param subject код родителя
 */
function setQuote(id, subject) {
    var is_new = true;
    if ($('#m' + id).hasClass('lk')) {
        is_new = false;
    }
    $('.description .message').each(function(i, elem) {
        if ($(this).hasClass("lk")) {
            $(this).removeClass('lk');
        }
    });
    $('#descript').text('');
    $('#message_parent').val(subject);
    if (is_new) {
        $('#m' + id).addClass('lk');
        $('#descript').text('Цитата:');
        $('#message_parent').val(id);
        $('#message_text').focus();
    }
}

/**
 * Редактирование сообщения
 * @param id код сообщения
 * @param text текст сообщения
 * @param subject код родителя
 */
function setEdit(id, text, subject) {
    var is_new = true;
    if ($('#m' + id).hasClass('lk')) {
        is_new = false;
    }
    $('.description .message').each(function(i, elem) {
        if ($(this).hasClass("lk")) {
            $(this).removeClass('lk');
        }
    });
    $('#descript').text('');
    $('#message_parent').val(subject);
    $('#message_text').val('');
    if (is_new) {
        $('#m' + id).addClass('lk');
        $('#descript').text('Редактирование:');
        $('#message_parent').val('-' + id);
        $('#message_text').val(text);
        $('#message_text').focus();
    }
}

/**
 * Замена иконки при разворачивании таблицы детализации
 * @param id код элемента изображения
 */
function viewCollapseIcon(id) {
    var src = $('img#i' + id).attr('src');
    var out = '';
    if (src.indexOf("plus1.png") + 1 > 0) {
        out = src.replace("plus1.png", "plus2.png");
    } else {
        out = src.replace("plus2.png", "plus1.png");
    }
    $('img#i' + id).attr('src', out);
}

/**
 * Подтверждение удаления записи
 * @param sender
 * @returns {boolean}
 */
function confirmDelete(sender, question) {
    if ($(sender).attr("confirmed") == "true") { return true; }
    bootbox.confirm({
        message: question,
        buttons: {
            confirm: {
                label: 'Да',
                className: 'btn btn-success'
            },
            cancel: {
                label: 'Нет',
                className: 'btn btn-danger'
            }
        }
        ,callback: function (confirmed) {
            if (confirmed) {
                $(sender).attr('confirmed', confirmed);
                sender.click();
            }
        }});
    return false;
}



$(document).ready(function(){
    // высплывающие подсказки
    $('[data-toggle="tooltip"]').tooltip();

    // активность пользователя записать в базу
    var id = $('button img.userid').attr('id');
    if (typeof(id) != 'undefined') {
        $.ajax({
            url: '/active',
            cache: false,
            type: 'post',
            data: "id=" + id
        });
    }
});