extends Area2D

var is_empty: bool:
    get:
        return (!get_overlapping_areas()&&!has_overlapping_bodies())
