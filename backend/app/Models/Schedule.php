<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Schedule extends Model
{
    protected $fillable = [
        'court_id',
        'day_of_week',
        'open_time',
        'close_time',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
    ];

    public function court(): BelongsTo
    {
        return $this->belongsTo(Court::class);
    }
}
