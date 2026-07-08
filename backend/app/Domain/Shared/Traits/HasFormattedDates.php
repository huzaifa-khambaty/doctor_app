<?php

namespace App\Domain\Shared\Traits;

use DateTimeInterface;

trait HasFormattedDates
{
    /**
     * Prepare a date for array / JSON serialization.
     *
     * @param  \DateTimeInterface  $date
     * @return string
     */
    protected function serializeDate(DateTimeInterface $date)
    {
        return $date->setTimezone(config('app.timezone'))->format('Y-m-d h:i:s A');
    }
}
