const mongoose = require( 'mongoose' );

const ChatMessageSchema = new mongoose.Schema( {
    sender: {
        type: String,
        required: [ true, "Sender is Mandatory" ],
        trim: true
    },
    receiver: {
        type: String,
        required: [ true, "Receiver is Mandatory" ],
        trim: true
    },
    message: {
        type: String,
        required: [ true, "Message is Mandatory" ],
        trim: true
    },
}, { timestamps: true } );

const ChatMessage = mongoose.model( 'ChatMessage', ChatMessageSchema );
module.exports = ChatMessage;