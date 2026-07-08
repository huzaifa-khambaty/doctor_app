<x-mail::message>
# Verification Code

Here is your one-time verification code for **{{ $purpose }}**:

<x-mail::panel>
**{{ $code }}**
</x-mail::panel>

This code is valid for 10 minutes. Please do not share it with anyone.

Thanks,<br>
{{ config('app.name') }}
</x-mail::message>
