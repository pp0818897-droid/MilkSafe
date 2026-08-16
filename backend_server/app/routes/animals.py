from flask import Blueprint, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.utils.responses import success_response, error_response
from app.models.animals import Animal
from app.models.farmers import Farmer
from mongoengine.queryset.visitor import Q

animals_bp = Blueprint('animals', __name__)

@animals_bp.route('/', methods=['POST'])
@jwt_required()
def add_animal():
    farmer_id = get_jwt_identity()
    farmer = Farmer.objects(id=farmer_id).first()

    if not farmer:
        return error_response("Only registered farmers can add animals", 403)

    data = request.get_json() or {}
    required = ["species", "tag_number"]
    
    if not all(data.get(f) for f in required):
        return error_response("Missing required fields: species, tag_number", 400)

    if Animal.objects(tag_number=data.get("tag_number")).first():
        return error_response("Tag number already exists", 409)

    animal = Animal(
        farmer=farmer,
        species=data.get("species"),
        breed=data.get("breed"),
        tag_number=data.get("tag_number"),
        age=data.get("age"),
        gender=data.get("gender"),
        weight=data.get("weight"),
        is_lactating=data.get("is_lactating", False),
        daily_milk_yield=data.get("daily_milk_yield", 0),
        pregnancy_status=data.get("pregnancy_status", "unknown")
    )
    animal.save()
    
    return success_response(animal.to_json(), 201)


@animals_bp.route('/', methods=['GET'])
@jwt_required()
def get_my_animals():
    farmer_id = get_jwt_identity()
    farmer = Farmer.objects(id=farmer_id).first()

    if not farmer:
        return error_response("Farmer not found", 404)

    animals = Animal.objects(farmer=farmer, is_active=True)
    return success_response([a.to_json() for a in animals], 200)


@animals_bp.route('/<animal_id>', methods=['GET'])
@jwt_required()
def get_animal(animal_id):
    animal = Animal.objects(id=animal_id).first()
    if not animal:
        return error_response("Animal not found", 404)
        
    return success_response(animal.to_json(), 200)


@animals_bp.route('/<animal_id>', methods=['PUT'])
@jwt_required()
def update_animal(animal_id):
    farmer_id = get_jwt_identity()
    
    animal = Animal.objects(id=animal_id).first()
    if not animal:
        return error_response("Animal not found", 404)
        
    if str(animal.farmer.id) != str(farmer_id):
        return error_response("Not authorized to update this animal", 403)

    data = request.get_json() or {}
    
    for field in ['age', 'weight', 'is_lactating', 'daily_milk_yield', 'pregnancy_status', 'current_health_issues']:
        if field in data:
            setattr(animal, field, data[field])
            
    animal.save()
    return success_response(animal.to_json(), 200)
