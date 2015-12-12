//
//  Store.swift
//  MySQL
//
//  Created by Alsey Coleman Miller on 12/11/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation
import CoreModel

public extension MySQL {
    
    /// **CoreModel** ```Store``` interface for **MySQL**.
    public final class Store: CoreModel.Store {
        
        /// Name of the column reserved for resource IDs.
        public static let resourceIDColumnName = "_id"
        
        // MARK: - Properties
        
        /// The model the persistent store will handle.
        public let model: CoreModel.Model
        
        public var connection: MySQL.Connection
        
        // MARK: - Initialization
        
        public init(model: Model, connection: MySQL.Connection) {
            
            self.model = model
            self.connection = connection
        }
        
        // MARK: - Methods
        
        /// Convenience method for creating tables.
        public func setupSchema(maxString: Int = 255) throws {
            
            for (entityName, entity) in self.model {
                
                var statement = "CREATE TABLE " + entityName
                
                statement += "\n(\n"
                
                // set primary key
                statement += Store.resourceIDColumnName + " " +
                
                for
            }
        }
        
        // MARK: Store Methods
        
        /// Queries the store for entities matching the fetch request.
        public func fetch(fetchRequest: CoreModel.FetchRequest) throws -> [CoreModel.Resource] {
            
            let entityName = fetchRequest.entityName
            
            let statement = "select"
            
            fatalError()
        }
        
        /// Determines whether the specified resource exists.
        public func exists(resource: CoreModel.Resource) throws -> Bool {
            
            fatalError()
        }
        
        /// Determines whether the specified resources exist.
        public func exist(resources: [CoreModel.Resource]) throws -> Bool {
            
            fatalError()
        }
        
        /// Creates an entity with the specified values.
        public func create(resource: CoreModel.Resource, initialValues: CoreModel.ValuesObject) throws {
            
            fatalError()
        }
        
        /// Deletes the specified entity.
        public func delete(resource: CoreModel.Resource) throws {
            
            fatalError()
        }
        
        /// Edits the specified entity.
        public func edit(resource: CoreModel.Resource, changes: CoreModel.ValuesObject) throws {
            
            fatalError()
        }
        
        /// Returns the entity's values.
        public func values(resource: CoreModel.Resource) throws -> CoreModel.ValuesObject {
            
            fatalError()
        }
    }
}
