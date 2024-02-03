@safetestset "Quantum Model" begin 
    @safetestset "predict" begin 
        using Distributions
        using QuantumContextEffectModels
        using Random 
        using Test
        
        Random.seed!(5874)

        dist = Dirichlet(fill(1, 4))
        for _ ∈ 1:10 
            parms = (
                Ψ = sqrt.(rand(dist)),
                θli = rand(Uniform(-1, 1)),
                θpb = rand(Uniform(-1, 1)),
            )
            
            model = QuantumModel(; parms...)
            preds = predict(model)
            
            @test all(x -> x ≈ 1, sum.(preds))
            @test length(preds) == 6
        end
    end

    @safetestset "predict" begin 
        using Distributions
        using QuantumContextEffectModels
        using Random 
        using Test
        
        Random.seed!(6620)

        n_sim = 1000
        cnt = 0
        n_reps = 100
        df = (4 - 1) * 6

        for _ ∈ 1:n_reps 
            # parameters such that expected responses ≥ 5
            parms = (
                Ψ = sqrt.([.25,.25,.3,.2]),
                θli = -.2,
                θpb = .1,
            )
            model = QuantumModel(; parms...)
            responses = vcat(rand(model, n_sim)...)
            expected_responses = vcat(predict(model) * n_sim...)
            Χ² = sum((responses .- expected_responses).^2 ./ expected_responses)
            cnt += (1 - cdf(Chisq(df), Χ²)) ≤ .05 ? 1 : 0
        end
        @test 1 - cdf(Binomial(n_reps, .05), cnt) ≥ .05
    end
end