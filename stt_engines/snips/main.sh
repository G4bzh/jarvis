#!/bin/bash
_snips_transcribe () {

    if [[ ! -f "stt_engines/snips/assistant/assistant.json" ]]; then
        jv_error "\nERROR: assistant for '$trigger' not found"
        jv_warning "HELP: Create your assistant on snips.ai"
        jv_warning "HELP: Download it, extract it"
        jv_warning "HELP: Copy 'assistant.json' and folder 'custom_asr' into stt_engines/snips/assistant"
        jv_exit 1
    fi


    snips_ret=`snips-asr -a stt_engines/snips/assistant file $audiofile 2>/dev/null`
    snips_order=`echo $snips_ret  | cut -d ':' -f 4 | grep -o '".*"' | sed 's/"//g'`
    $verbose && jv_debug "DEBUG: $snips_ret"
    $verbose && jv_debug "DEBUG: $snips_order"
    echo $snips_order > $forder
}

snips_STT () { # STT () {} Transcribes audio file $1 and writes corresponding text in $forder
    LISTEN $audiofile || return $?
    _snips_transcribe &
   jv_spinner $!
}
