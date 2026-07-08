<?php

namespace App\Domain\Admin\Policies;

use App\Domain\Admin\Models\Admin;
use App\Domain\Doctor\Models\User;
use Illuminate\Auth\Access\HandlesAuthorization;

class UserPolicy
{
    use HandlesAuthorization;

    public function verify(Admin $admin, User $user)
    {
        return $user->status === 'pending'
            ? $this->allow()
            : $this->deny('User is not in pending status.');
    }

    public function suspend(Admin $admin, User $user)
    {
        return $user->status === 'verified'
            ? $this->allow()
            : $this->deny('Only verified users can be suspended.');
    }

    public function reinstate(Admin $admin, User $user)
    {
        return $user->status === 'suspended'
            ? $this->allow()
            : $this->deny('Only suspended users can be reinstated.');
    }
}
