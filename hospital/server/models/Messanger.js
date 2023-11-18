const mongoose = require( 'mongoose' );

const messageSchema = new mongoose.Schema( {
    sender: {
        type: mongoose.Schema.Types.ObjectId,
        refPath: 'senderType', // Dynamic reference based on senderType field
        required: true,
    },
    recipient: {
        type: mongoose.Schema.Types.ObjectId,
        refPath: 'recipientType', // Dynamic reference based on recipientType field
        required: true,
    },
    senderType: {
        type: String,
        enum: [ 'Doctor', 'Patient' ], // Enumerate sender types
        required: true,
    },
    recipientType: {
        type: String,
        enum: [ 'Doctor', 'Patient' ], // Enumerate recipient types
        required: true,
    },
    message: {
        type: String,
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
} );

const Message = mongoose.model( 'Message', messageSchema );

module.exports = Message;
