<?php

namespace App\Domain\Admin\Policies;

use App\Domain\Admin\Models\Admin;
use App\Domain\Shared\Models\Event;
use Illuminate\Auth\Access\HandlesAuthorization;

class EventPolicy
{
    use HandlesAuthorization;

    public function viewAny(Admin $admin)
    {
        return $admin->hasPermissionTo('events.view');
    }

    public function view(Admin $admin, Event $event)
    {
        return $admin->hasPermissionTo('events.view');
    }

    public function create(Admin $admin)
    {
        return $admin->hasPermissionTo('events.create');
    }

    public function update(Admin $admin, Event $event)
    {
        if (!$admin->hasPermissionTo('events.edit')) {
            return false;
        }

        // Only editable in draft or review (or unpublished to fix and republish)
        return in_array($event->status, ['draft', 'review', 'unpublished']);
    }

    public function submitForReview(Admin $admin, Event $event)
    {
        return $admin->hasPermissionTo('events.edit') && in_array($event->status, ['draft', 'unpublished']);
    }

    public function publish(Admin $admin, Event $event)
    {
        return $admin->hasPermissionTo('events.publish') && in_array($event->status, ['draft', 'review', 'unpublished']);
    }

    public function unpublish(Admin $admin, Event $event)
    {
        return $admin->hasPermissionTo('events.publish') && $event->status === 'published';
    }

    public function delete(Admin $admin, Event $event)
    {
        return $admin->hasPermissionTo('events.delete');
    }
}
