module.exports = class BaseModel extends Backbone.Model


    getSummary:  ->
        switch @get('docType').toLowerCase()
            when 'contact'

                image = if @get('_attachments')?.picture then "images/contact/#{@get('_id')}/picture"
                else 'img/contact.png'

                title: @get 'fn'
                image: image

            when 'phonecommunicationlog'
                date = Date.create @get 'timestamp'

                direction = if @get('direction') is 'OUTGOING' then 'sortant'
                else 'entrant'

                title: 'Appel ' + direction
                image: 'img/phonecalllog.png'
                content: formatDuration @get 'chipCount'

            when 'bankoperation'

                type = if @get('amount') < 0 then 'Débit : ' else 'Crédit : '

                title: @get('title')
                image: 'img/bankoperation.png'
                content: type + @get('amount') + '€'

            when 'receipt'
                title: 'Ticket de Caisse'
                image: 'img/receipt.png'

            when 'error'
                image: 'http://placehold.it/64&text=:('
                title: @get('error') or 'Error'

            else
                image: 'http://placehold.it/64&text=?'
                title: @get('title') or '???'



formatDuration = (seconds) ->
    seconds = parseInt seconds
    s = seconds % 60
    m = ((seconds - s) % 3600) / 60
    h = ((seconds - s - m*60)) / 3600
    out = s + 's'
    out = m + 'min ' + out if m
    out = h + 'h '   + out if h
    return out