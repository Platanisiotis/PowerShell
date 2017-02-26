﻿Function Get-EventID
{
    [CmdletBinding(PositionalBinding=$false,
                  ConfirmImpact='Medium')]
    [OutputType([String])]
    Param
    (
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0)]
        [ValidateSet("36887")]
        [Alias("cheat")] 
        $ID
    )

    Begin
    {
        $Object = @()

    }
    Process
    {
        switch ($ID) 
        {
            36887 
            {
                $CollectionStats = @(
                    ('0','close_notify','Notifies the recipient that the sender will not send any more messages on this connection.'),
                    ('10','unexpected_message','Received an inappropriate message This alert should never be observed in communication between proper implementations. This message is always fatal.'),
                    ('20','bad_record_mac','Received a record with an incorrect MAC. This message is always fatal.'),
                    ('21','decryption_failed','Decryption of a TLSCiphertext record is decrypted in an invalid way: either it was not an even multiple of the block length or its padding values, when checked, were not correct. This message is always fatal.'),
                    ('22','record_overflow','Received a TLSCiphertext record which had a length more than 2^14+2048bytes, or a record decrypted to a TLSCompressed record with more than2^14+1024 bytes. This message is always fatal.'),
                    ('30','decompression_failure','Received improper input, such as data that would expand to excessive length, from the decompression function. This message is always fatal.'),
                    ('40','handshake_failure','Indicates that the sender was unable to negotiate an acceptable set of security parameters given the options available. This is a fatal error.'),
                    ('42','bad_certificate','There is a problem with the certificate, for example, a certificate is corrupt, or a certificate contains signatures that cannot be verified.'),
                    ('43','unsupported_certificate','Received an unsupported certificate type.'),
                    ('44','certificate_revoked','Received a certificate that was revoked by its signer.'),
                    ('45','certificate_expired','Received a certificate has expired or is not currently valid.'),
                    ('46','certificate_unknown','An unspecified issue took place while processing the certificate that made it unacceptable.'),
                    ('47','illegal_parameter','Violated security parameters, such as a field in the handshake was out of range or inconsistent with other fields. This is always fatal.'),
                    ('48','unknown_ca','Received a valid certificate chain or partial chain, but the certificate was not accepted because the CA certificate could not be located or could not be matched with a known, trusted CA. This message is always fatal.'),
                    ('49','access_denied','Received a valid certificate, but when access control was applied, the sender did not proceed with negotiation. This message is always fatal.'),
                    ('50','decode_error','A message could not be decoded because some field was out of the specified range or the length of the message was incorrect. This message is always fatal.'),
                    ('51','decrypt_error','Failed handshake cryptographic operation, including being unable to correctly verify a signature, decrypt a key exchange, or validate a finished message.'),
                    ('60','export_restriction','Detected a negotiation that was not in compliance with export restrictions; for example, attempting to transfer a 1024 bit ephemeral RSA key for theRSA_EXPORT handshake method. This message is always fatal.'),
                    ('70','protocol_version','The protocol version the client attempted to negotiate is recognized, but not supported. For example, old protocol versions might be avoided for security reasons. This message is always fatal.'),
                    ('71','insufficient_security','Failed negotiation specifically because the server requires ciphers more secure than those supported by the client. Returned instead of handshake_failure. This message is always fatal.'),
                    ('80','internal_error','An internal error unrelated to the peer or the correctness of the protocol makes it impossible to continue, such as a memory allocation failure. The error is not related to protocol. This message is always fatal.'),
                    ('90','user_cancelled','Cancelled handshake for a reason that is unrelated to a protocol failure. If the user cancels an operation after the handshake is complete, just closing the connection by sending a close_notify is more appropriate. This alert should be followed by a close_notify. This message is generally a warning.'),
                    ('100','no_renegotiation','Sent by the client in response to a hello request or sent by the server in response to a client hello after initial handshaking. Either of these would normally lead to renegotiation; when that is not appropriate, the recipient should respond with this alert; at that point, the original requester can decide whether to proceed with the connection. One case where this would be appropriate would be where a server has spawned a process to satisfy a request; the process might receive security parameters (key length, authentication, and so on) at start-up and it might be difficult to communicate changes to these parameters after that point. This message is always a warning.'),
                    ('255','unsupported_extension','')
                )
                foreach ($Stat in $CollectionStats)
                {
                    [pscustomobject]@{
                        "Code"= $Stat[0];
                        "Message"= $Stat[1];
                        "Description"= $Stat[2];

                    }
                }
            }
        }
    }
}