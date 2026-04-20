<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Booking extends Model
{
    protected $fillable = [
        'court_id',
        'guest_name',
        'guest_email',
        'guest_phone',
        'booking_date',
        'start_time',
        'end_time',
        'total_price',
        'status',
        'notes',
    ];

    protected $casts = [
        'booking_date' => 'date',
        'total_price' => 'decimal:2',
    ];

    public function court(): BelongsTo
    {
        return $this->belongsTo(Court::class);
    }
}
