<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Court extends Model
{
    protected $fillable = [
        'name',
        'surface',
        'is_indoor',
        'is_available',
        'description',
        'image_url',
    ];

    protected $casts = [
        'is_indoor' => 'boolean',
        'is_available' => 'boolean',
    ];

    public function bookings(): HasMany
    {
        return $this->hasMany(Booking::class);
    }

    public function schedules(): HasMany
    {
        return $this->hasMany(Schedule::class);
    }

    public function prices(): HasMany
    {
        return $this->hasMany(Price::class);
    }
}
